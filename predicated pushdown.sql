
--requirement: to filter event_name = 'view_item' from event_table

--without predicated pushdown. during filtering 'view_item', 
-- for query below: filtering 'view_item' done after joining table. reduce performance as it scanned entire data instead of only from event_table.

SELECT 
id, 
email_address, 
first_name, 
last_name,
event_name
FROM 
(
	SELECT 
	user_id,
	event_name
	FROM dsv1069.events
) event_table
LEFT JOIN
(
	SELECT 
	id, 
	email_address, 
	first_name, 
	last_name
	FROM dsv1069.users
) user_table
ON event_table.user_id=user_table.id
WHERE event_name = 'view_item'


-- With predicated pushdown.
-- As the filter is only required from event_table (view_item), the filter is done initially at event_table before joining both table. Thus, it only scanned the event_table during filtering
-- Thus, by doing so, it help to optimized the performance, reduce timing of unnecessarily scanning entire table.

SELECT 
id, 
email_address, 
first_name, 
last_name,
event_name
FROM 
(
	SELECT 
	user_id,
	event_name
	FROM dsv1069.events
	WHERE event_name = 'view_item'
) event_table

LEFT JOIN
(
	SELECT 
	id, 
	email_address, 
	first_name, 
	last_name
	FROM dsv1069.users
) user_table
ON event_table.user_id=user_table.id