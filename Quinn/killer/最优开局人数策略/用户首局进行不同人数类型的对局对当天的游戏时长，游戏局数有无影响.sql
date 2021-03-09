
SELECT t3.date,
       t3.playerCount,
       t4.game_num,
       t4.duration
FROM
  (SELECT t2.date,
          t2.playerCount,
          t2.distinct_id
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('20014',
                      '30015')
        AND date BETWEEN '2020-10-20' AND current_date()- interval 1 DAY
      GROUP BY 1,
               2)t1
   LEFT JOIN
     (SELECT date,distinct_id,
                  playerCount
      FROM events
      WHERE event = 'gameStart'
        AND game_played = 0
        AND date BETWEEN '2020-10-20' AND current_date()- interval 1 DAY
      GROUP BY 1,
               2,
               3)t2 ON t1.distinct_id = t2.distinct_id
   AND t1.date = t2.date
   GROUP BY 1,
            2,
            3) t3
JOIN
  (SELECT date,distinct_id,
               count(distinct_id) AS game_num,
               sum(duration/60000)AS duration
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-10-20' AND current_date()- interval 1 DAY
   GROUP BY 1,
            2)t4 ON t3.date = t4.date
AND t3.distinct_id = t4.distinct_id
WHERE t3.playerCount BETWEEN 4 AND 10
ORDER BY 1,
         2