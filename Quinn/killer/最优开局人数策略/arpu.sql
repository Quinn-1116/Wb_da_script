--新用户留存

SELECT t4.date,
       t4.playerCount,
       sum(t5.pay)/count(t5.distinct_id)AS arppu,
       sum(t5.pay)/count(DISTINCT t4.distinct_id)AS arpu
FROM
  (SELECT t2.*
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'register'
        AND appId IN ('20014',
                      '30014')
        AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
      GROUP BY 1,
               2)t1
   JOIN
     (SELECT date,distinct_id,
                  playerCount,
                  count(distinct_id)AS game_num
      FROM events
      WHERE event = 'gameStart'
        AND gameTypeId = 1800
        AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
      GROUP BY 1,
               2,
               3)t2 ON t1.date = t2.date
   AND t1.distinct_id = t2.distinct_id
   JOIN
     (SELECT date,distinct_id,
                  count(distinct_id)AS total_game_num,
                  sum(duration/60000)AS duration
      FROM events
      WHERE event = 'gameOver'
        AND gameTypeId = 1800
        AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
      GROUP BY 1,
               2)t3 ON t1.date = t3.date
   AND t1.distinct_id = t3.distinct_id HAVING t2.game_num/t3.total_game_num >= 0.5) t4
LEFT JOIN
  (SELECT date,distinct_id,
               sum(pay) AS pay
   FROM events
   WHERE event = 'pay'
     AND appId IN ('20014',
                   '30015')
     AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
   GROUP BY 1,
            2)t5 ON t4.date = t5.date
AND t4.distinct_id = t5.distinct_id
GROUP BY 1,
         2
ORDER BY 1,
         2