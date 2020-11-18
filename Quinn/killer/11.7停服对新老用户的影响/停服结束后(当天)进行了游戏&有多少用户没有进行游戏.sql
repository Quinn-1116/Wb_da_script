SELECT t2.date,
       t1.appid,
       count(t2.distinct_id)
FROM
  (SELECT appId,
          distinct_id
   FROM events
   WHERE event = 'register'
     AND appId in('20014','30015')
     AND date = '2020-11-07'
     AND time BETWEEN '2020-11-07 09:00:00' AND '2020-11-07 12:00:00'
   GROUP BY 1,
            2)t1
LEFT JOIN
  (SELECT date, distinct_id
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND game_played = 0
     AND date >= '2020-11-07'
     and time >= '2020-11-07 12:00:00'
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
GROUP BY 1,
         2
ORDER BY 1