SELECT t1.date,
       count(t1.distinct_id)AS regist_num,
       count(t2.distinct_id)AS game_num,
       count(t2.distinct_id)/count(t1.distinct_id)AS `对照组新用户太空杀游戏率`
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'register'
     AND date BETWEEN '2021-02-04' AND '2021-02-11'
     AND cast(right(distinct_id,1) AS bigint)<=4
     AND appId IN ('10001',
                   '10002')
   GROUP BY 1,
            2)t1
LEFT JOIN
  (SELECT date, distinct_id
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId =1800
     AND game_played = 0
     AND appId IN ('10001',
                   '10002')
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
GROUP BY 1
ORDER BY 1


SELECT t1.date,
       count(t1.distinct_id)AS regist_num,
       count(t2.distinct_id)AS game_num,
       count(t2.distinct_id)/count(t1.distinct_id)AS `实验组新用户太空杀游戏率`
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'register'
     AND date BETWEEN '2021-02-04' AND '2021-02-11'
     AND cast(right(distinct_id,1) AS bigint)>4
     AND appId IN ('10001',
                   '10002')
   GROUP BY 1,
            2)t1
LEFT JOIN
  (SELECT date, distinct_id
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId =1800
     AND game_played = 0
     AND appId IN ('10001',
                   '10002')
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
GROUP BY 1
ORDER BY 1