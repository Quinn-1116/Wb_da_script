
SELECT t0.game_level
FROM
  (SELECT distinct_id,
          game_level,
          time,
          row_number()over(partition BY distinct_id
                           ORDER BY time DESC) AS time_rank
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-30' AND current_date()
   GROUP BY 1,
            2,
            3)t0
WHERE t0.time_rank = 1