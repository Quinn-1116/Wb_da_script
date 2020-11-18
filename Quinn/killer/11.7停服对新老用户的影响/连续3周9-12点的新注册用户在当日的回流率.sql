SELECT t1.date,
       count(t1.distinct_id)AS `停服期间的新注册用户` ,
       count(t2.distinct_id)AS `停服结束后当日又进行游戏的新用户`,
       count(t2.distinct_id)/count(t1.distinct_id) AS `新增注册游戏回流率`
FROM
  (SELECT date, distinct_id
   FROM events
   WHERE event = 'register'
     AND appId in('20014','30015')
     AND date = '2020-11-14'
     AND time BETWEEN '2020-11-14 09:00:00' AND '2020-11-14 11:59:59'
   GROUP BY 1,
            2)t1
LEFT JOIN
  (SELECT date, distinct_id
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND game_played = 0
     AND date = '2020-11-14'
     AND time >= '2020-11-14 12:00:00'
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
AND t1.date = t2.date
GROUP BY 1





SELECT t1.date,
       count(t1.distinct_id)AS `停服期间的新注册用户` ,
       count(t2.distinct_id)AS `停服结束后当日又进行登录的新用户`,
       count(t2.distinct_id)/count(t1.distinct_id) AS `新增注册app回流率`
FROM
  (SELECT date, distinct_id
   FROM events
   WHERE event = 'register'
     AND appId in('20014','30015')
     AND date = '2020-10-31'
     AND time BETWEEN '2020-10-31 09:00:00' AND '2020-10-31 11:59:59'
   GROUP BY 1,
            2)t1
LEFT JOIN
  (SELECT date, distinct_id
   FROM events
   WHERE event = 'login'
     AND date = '2020-10-31'
     AND time >= '2020-10-31 12:00:00'
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
AND t1.date = t2.date
GROUP BY 1