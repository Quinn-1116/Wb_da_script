SELECT t30.*,
       t40.*,
       t30.reten_num/t40.game_num
FROM
  (SELECT t10.date,
          t10.playerCount,
          datediff(t20.date,t10.date)AS date_gap,
          count(t20.distinct_id) AS reten_num
   FROM
     (SELECT t2.*,
             t3.total_game_num,
             t2.game_num/t3.total_game_num AS p_
      FROM
        (SELECT t5.date,
                t5.distinct_id
         FROM
           (SELECT date,distinct_id
            FROM events
            WHERE event = 'register'
              AND appId IN ('20014',
                            '30014')
              AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
            GROUP BY 1,
                     2)t4
         RIGHT JOIN
           (SELECT date,distinct_id
            FROM events
            WHERE event = 'login'
              AND appId IN ('20014',
                            '30014')
              AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
            GROUP BY 1,
                     2)t5 ON t4.date = t5.date
         AND t4.distinct_id = t5.distinct_id
         WHERE t4.distinct_id IS NULL)t1
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
                     count(distinct_id)AS total_game_num
         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
         GROUP BY 1,
                  2)t3 ON t1.date = t3.date
      AND t1.distinct_id = t3.distinct_id HAVING t2.game_num/t3.total_game_num >= 0.5) t10
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('20014',
                      '30014')
        AND date BETWEEN '2020-10-21' AND current_date()- interval 1 DAY
      GROUP BY 1,
               2)t20 ON t10.distinct_id = t20.distinct_id
   AND datediff(t20.date,t10.date) BETWEEN 1 AND 6
   GROUP BY 1,
            2,
            3)t30
JOIN
  (SELECT t0.date,t0.playerCount,
                  count(t0.distinct_id)AS game_num
   FROM
     (SELECT t2.*,
             t3.total_game_num,
             t2.game_num/t3.total_game_num AS p_
      FROM
        (SELECT t5.date, t5.distinct_id
         FROM
           (SELECT date,distinct_id
            FROM events
            WHERE event = 'register'
              AND appId IN ('20014',
                            '30014')
              AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
            GROUP BY 1,
                     2)t4
         RIGHT JOIN
           (SELECT date,distinct_id
            FROM events
            WHERE event = 'login'
              AND appId IN ('20014',
                            '30014')
              AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
            GROUP BY 1,
                     2)t5 ON t4.date = t5.date
         AND t4.distinct_id = t5.distinct_id
         WHERE t4.distinct_id IS NULL)t1
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
                     count(distinct_id)AS total_game_num
         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
         GROUP BY 1,
                  2)t3 ON t1.date = t3.date
      AND t1.distinct_id = t3.distinct_id HAVING t2.game_num/t3.total_game_num >= 0.5)t0
   GROUP BY 1,
            2)t40 ON t30.date = t40.date
AND t30.playerCount = t40.playerCount
ORDER BY t30.date,t30.playerCount,
                  t30.date_gap order by 