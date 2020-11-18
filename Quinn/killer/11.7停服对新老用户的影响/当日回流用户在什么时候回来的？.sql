
SELECT t2.hour,
       t2.MINUTE,
       count(t2.distinct_id)AS `回流用户数`
FROM
  (SELECT date, distinct_id
   FROM events
   WHERE event = 'register'
     AND appId in('20014','30015')
     AND date = '2020-11-07'
     AND time BETWEEN '2020-11-07 09:00:00' AND '2020-11-07 12:00:00'
   GROUP BY 1,
            2) t1
LEFT JOIN
  (SELECT date,hour(time) hour,
               minute(time) MINUTE,
                            distinct_id
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND game_played = 0
     AND date = '2020-11-07'
   GROUP BY 1,
            2,
            3,
            4) t2 ON t1.date = t2.date
AND t1.distinct_id =t2.distinct_id
WHERE t2.distinct_id IS NOT NULL
GROUP BY 1,
         2
ORDER BY 1,
         2