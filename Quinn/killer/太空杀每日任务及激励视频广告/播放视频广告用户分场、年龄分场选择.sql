--点击广告的游戏分场选择

SELECT t2.date,
       t2.gameSubtype,
       count(t2.distinct_id)as game_sub_num
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'behavior'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2) t1
JOIN
  (SELECT date,distinct_id,
               gameSubType
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date()- interval 1 DAY
   GROUP BY 1,
            2,
            3)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
GROUP BY 1,
         2
ORDER BY 1,
         2




SELECT t2.date,
       t2.ageType,
       count(t2.distinct_id)as age_sub_num
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'behavior'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2) t1
JOIN
  (SELECT date,distinct_id,
               ageType
   FROM events
   WHERE event = 'roomAllocate'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date()- interval 1 DAY
   GROUP BY 1,
            2,
            3)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
GROUP BY 1,
         2
ORDER BY 1,
         2







SELECT t2.date,
       t2.gameSubtype,
       count(t2.distinct_id)as game_sub_num
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'behavior'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2) t1
right JOIN
  (SELECT date,distinct_id,
               gameSubType
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date()- interval 1 DAY
   GROUP BY 1,
            2,
            3)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
where t1.distinct_id is null
GROUP BY 1,
         2
ORDER BY 1,
         2



SELECT t2.date,
       t2.ageType,
       count(t2.distinct_id)as age_sub_num
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'behavior'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2) t1
right JOIN
  (SELECT date,distinct_id,
               ageType
   FROM events
   WHERE event = 'roomAllocate'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date()- interval 1 DAY
   GROUP BY 1,
            2,
            3)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
where t1.distinct_id is null
GROUP BY 1,
         2
ORDER BY 1,
         2
