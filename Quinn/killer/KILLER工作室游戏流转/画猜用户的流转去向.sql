 --以画猜(101) 五子棋(1206) 台球(1225,1226)为起点的用户流转

SELECT t1.date,
       t2.gameTypeId,
       datediff(t2.date,t1.date)AS date_gap,
       count(t2.distinct_id)
FROM
  (SELECT t1.date,
          t2.distinct_id,
          t2.gameTypeId,
          t2.time
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'register'
        AND appId IN ('10001',
                      '10002')
        AND date BETWEEN '2021-03-01' AND '2021-03-07'
      GROUP BY 1,
               2)t1
   JOIN
     (SELECT *
      FROM
        (SELECT date,distinct_id,
                     gameTypeId,
                     time,
                     row_number()over(partition BY distinct_id
                                      ORDER BY time)AS time_rank
         FROM events
         WHERE event = 'gameStart'
           AND date BETWEEN '2021-03-01' AND '2021-03-07'
           AND game_played = 0)t0
      WHERE t0.time_rank = 1
        AND gameTypeId in(1225,1226))t2 ON t1.distinct_id = t2.distinct_id
   AND datediff(t2.date,t1.date) BETWEEN 0 AND 6
   GROUP BY 1,
            2,
            3,
            4)t1
LEFT JOIN
  (SELECT date,distinct_id,
               gameTypeId,
               time
   FROM events
   WHERE event = 'gameStart'
     AND game_played = 0
     AND date BETWEEN '2021-03-01' AND '2021-03-07'
   GROUP BY 1,
            2,
            3,
            4)t2 ON t1.distinct_id = t2.distinct_id
AND t2.time> t1.time
GROUP BY 1,
         2,
         3
ORDER BY 1,
         3,
         4 DESC