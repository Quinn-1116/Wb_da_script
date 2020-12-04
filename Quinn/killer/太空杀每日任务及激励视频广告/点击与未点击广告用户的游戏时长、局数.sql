--点击广告用户的游戏时长

SELECT t2.*
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'behavior'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t1
JOIN
  (SELECT date, distinct_id,
                gameSubtype,
                sum(duration/60000)AS MINUTE
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date()- interval 1 DAY
   GROUP BY 1,
            2,
            3)t2 ON t1.date = t2.date
AND t1.distinct_id =t2.distinct_id


--未点击广告用户的游戏时长
SELECT t1.*
FROM
  (SELECT date, distinct_id,
                gameSubtype,
                sum(duration/60000)AS MINUTE
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date()- interval 1 DAY
   GROUP BY 1,
            2,
            3)t1
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'behavior'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
AND t1.date = t2.date
WHERE t2.distinct_id IS NULL


--未点击广告用户的游戏局数
SELECT t1.*
FROM
  (SELECT date, distinct_id,
                gameSubtype,
                count(distinct_id)AS game_num
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date()- interval 1 DAY
   GROUP BY 1,
            2,
            3)t1
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'behavior'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
AND t1.date = t2.date
WHERE t2.distinct_id IS NULL

--点击广告用户的游戏局数
SELECT t1.*
FROM
  (SELECT date, distinct_id,
                gameSubtype,
                count(distinct_id)AS game_num
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date()- interval 1 DAY
   GROUP BY 1,
            2,
            3)t1 JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'behavior'
     AND SOURCE = 'video_adv'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
AND t1.date = t2.date




