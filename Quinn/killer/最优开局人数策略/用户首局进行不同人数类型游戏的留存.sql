
SELECT t5.date,
       t5.playerCount,
       t5.total_num,
       t6.date_gap,
       t6.reten_num,
       t6.reten_num/t5.total_num AS reten_p
FROM
  (SELECT t2.date,
          t2.playerCount,
          count(DISTINCT t2.distinct_id)AS total_num
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('20014',
                      '30015')
        
        AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
      GROUP BY 1,
               2)t1
   LEFT JOIN 
     (SELECT date,distinct_id,
                  playerCount
      FROM events
      WHERE event = 'gameStart'
        AND game_played = 0
        AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
      GROUP BY 1,
               2,
               3)t2 ON t1.distinct_id = t2.distinct_id
   AND t1.date = t2.date
   GROUP BY 1,
            2) t5
JOIN
  (SELECT t3.date, t3.playerCount,
                   datediff(t4.date,t3.date)AS date_gap ,
                   count(t4.distinct_id)AS reten_num
   FROM
     (SELECT t2.*
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'login'
           AND appId IN ('20014',
                         '30015')
           AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
         GROUP BY 1,
                  2)t1
      LEFT JOIN
        (SELECT date,distinct_id,
                     playerCount
         FROM events
         WHERE event = 'gameStart'
           AND game_played = 0
           AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
         GROUP BY 1,
                  2,
                  3)t2 ON t1.distinct_id = t2.distinct_id
      AND t1.date = t2.date)t3
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('20014',
                      '30015')
        AND date BETWEEN '2020-10-21' AND current_date()- interval 1 DAY
      GROUP BY 1,
               2)t4 ON t3.distinct_id = t4.distinct_id
   AND datediff(t4.date,t3.date) BETWEEN 1 AND 6
   GROUP BY 1,
            2,
            3)t6 ON t5.date = t6.date
AND t5.playerCount = t6.playerCount
WHERE t5.playerCount BETWEEN 4 AND 10
ORDER BY 1,
         2,
         t6.date_gap