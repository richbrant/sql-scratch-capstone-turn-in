/*
Section 1
*/

/*
count of distinct campaigns
*/


SELECT COUNT(DISTINCT utm_campaign) AS 'campaign_count'
FROM page_visits;

/*
count of distinct sources
*/

SELECT COUNT(DISTINCT utm_source) AS 'source_count'
FROM page_visits;

/*
campaigns and sources
*/


SELECT DISTINCT utm_campaign AS 'campaign', utm_source AS 'source'
FROM page_visits;

/*
distinct web pages
*/

SELECT DISTINCT page_name 
AS 'web_page'
FROM page_visits;

/*
Section 2
*/

/*
1st touch by campaign
*/

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
first_touch_att AS (SELECT ft.user_id,
    ft.first_touch_at,
    pv.utm_source,
		pv.utm_campaign
FROM first_touch ft
JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp)
SELECT first_touch_att.utm_source AS 'source', first_touch_att.utm_campaign AS 'campaign', COUNT(first_touch_att.first_touch_at) AS 'number_of_first_touch'
FROM first_touch_att
GROUP BY 2
ORDER BY 3 DESC;

/*
last touch by campaign
*/


WITH last_touch AS (SELECT user_id,
        MAX(timestamp) AS 'last_touch_at'
    FROM page_visits
    GROUP BY user_id),
last_touch_att AS (SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)
SELECT last_touch_att.utm_source AS 'source', last_touch_att.utm_campaign AS 'campaign', count(last_touch_att.last_touch_at) AS 'number_of_last_touch'
FROM last_touch_att
GROUP BY 2
ORDER BY 3 DESC;

/*
number of page lands on 'purchase'
*/


SELECT COUNT(DISTINCT user_id) AS 'purchasers'
FROM page_visits
WHERE page_name = '4 - purchase';

/*
last touch by campaign specifiaclly on purchase page
*/

WITH last_touch AS (SELECT user_id,
        MAX(timestamp) AS 'last_touch_at'
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
last_touch_att AS (SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)
SELECT last_touch_att.utm_source AS 'source', last_touch_att.utm_campaign AS 'campaign', count(last_touch_att.last_touch_at) AS 'number_of_last_touch'
FROM last_touch_att
GROUP BY 2
ORDER BY 3 DESC;





