-- Pre-Exercise Window Function Review & Practice

-- Gathering, partitioning, and ranking order information.

SELECT
  user_id,
  invoice_id,
  paid_at,
  DENSE_RANK() OVER (PARTITION BY user_id ORDER BY paid_at ASC)
    AS dense_order_num
FROM 
  dsv1069.orders
GROUP BY
  user_id, invoice_id, paid_at
ORDER BY
  invoice_id
;

----------------------------------------------------------------------------------------

-- Exercise 1: Create the right subtable for recently viewed events using the view_item_events table.

SELECT 
  user_id,
  item_id,
  event_time,
  DENSE_RANK() OVER (PARTITION BY user_id ORDER BY event_time DESC)
    AS view_number
FROM 
  dsv1069.view_item_events

/*
user_id	item_id	event_time	view_number
4	3924	2013-09-04 04:47:43	1
4	2712	2013-07-05 11:23:52	2
4	2248	2013-07-03 15:32:52	3
6	3953	2013-06-13 15:12:17	1
6	3280	2013-06-13 09:22:17	2
*/

----------------------------------------------------------------------------------------

-- Exercise 2: Check your joins. Join your tables together recent_views, users, items.

SELECT *
FROM 
  ( 
    SELECT
      user_id,
      item_id,
      event_time,
      ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_time DESC)
        AS view_number
    FROM 
      dsv1069.view_item_events
) recent_views
JOIN 
  dsv1069.users
ON 
  users.id = recent_views.user_id 
JOIN 
  dsv1069.items 
ON 
  items.id = recent_views.item_id

----------------------------------------------------------------------------------------

-- Exercise 3: Clean up your columns. 
-- The goal of all this is to return all of the information we’ll need to send users an email about the item they viewed more recently. 
-- Clean up this query outline from the outline in EX2 and pull only the columns you need. 
-- Make sure they are named appropriately so that another human can read and understand their contents.

SELECT 
  COALESCE(users.parent_user_id, users.id) AS user_id,
  users.email_address,
  items.id AS item_id,
  items.name AS item_name,
  items.category AS item_category
FROM 
  ( 
    SELECT
      user_id,
      item_id,
      event_time,
      ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY event_time DESC)
        AS view_number
    FROM 
      dsv1069.view_item_events
) recent_views
JOIN 
  dsv1069.users
ON 
  users.id = recent_views.user_id 
JOIN 
  dsv1069.items 
ON 
  items.id = recent_views.item_id
JOIN 
  dsv1069.orders
ON 
  orders.item_id = recent_views.item_id 
AND
  orders.user_id = recent_views.user_id
;

/*
user_id	email_address	item_id	item_name	item_category
57053	TambikaPetrov@gmail.net	1126	apparatus	apparatus
206123	TGupta1974@outlook.net	511	extra-strength mechanism storage_unit	mechanism
210121	Janelle_Petrov@yahoo.edu	3203	dongle carrying_case	dongle
173391	Lisa_Bertrand1971@earthlink.com	880	contraption warmer	contraption
49734	Elizabeth_Varghese@inbox.net	2700	organic mechanism	mechanism
*/

----------------------------------------------------------------------------------------



























