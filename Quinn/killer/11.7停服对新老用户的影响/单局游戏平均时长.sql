 --当天未回流的老用户的留存

SELECT t1.date,
       t1.gameSubType,
       avg(t1.duration)
FROM
  (SELECT date, gameSubType,
    
                match_id,
                duration /60000 AS duration
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date >= '2020-10-20'
   GROUP BY 1,
            2,
            3,
            4)t1
GROUP BY 1,
         2
ORDER BY 1,
         2