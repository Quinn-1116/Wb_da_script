
SELECT t1.date,
       t2.gameTypeId,
       count(t2.distinct_id)
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
   WHERE t0.time_rank = 1)t2 ON t1.distinct_id = t2.distinct_id
AND datediff(t2.date,t1.date) BETWEEN 0 AND 6
GROUP BY 1,
         2
ORDER BY 1,
         3 DESC