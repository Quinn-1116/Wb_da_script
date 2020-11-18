--回流用户：停服期间注册，停服结束后，当日有游戏行为的新注册用户
--当日回流用户的留存

SELECT t1.date,
       count(t1.distinct_id)AS `停服期间的新注册用户` ,
       count(t2.distinct_id)AS `停服结束后当日又进行游戏的新用户`,
       count(t2.distinct_id)/count(t1.distinct_id) AS `新增注册当日回流率`
FROM
  (SELECT date, distinct_id
   FROM events
   WHERE event = 'register'
     AND appId in('20014','30015')
     AND date = '2020-11-07'
     AND time BETWEEN '2020-11-07 09:00:00' AND '2020-11-07 11:59:59'
   GROUP BY 1,
            2)t1
LEFT JOIN
  (SELECT date, distinct_id
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND game_played = 0
     AND date = '2020-11-07'
     AND time >= '2020-11-07 12:00:00'
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
AND t1.date = t2.date
GROUP BY 1