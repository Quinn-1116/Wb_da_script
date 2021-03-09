SELECT t8.date,
       t8.playerCount,
       t8.total_num,
       t9.date_gap,
       t9.reten_num
FROM
  (SELECT t5.date,
          t5.playerCount,
          count(t5.distinct_id)AS total_num
   FROM
     (SELECT t4.*,
             row_number()over(partition BY t4.date,t4.distinct_id
                              ORDER BY t4.p_ DESC)AS rank
      FROM
        (SELECT t1.date,
                t1.distinct_id,
                t1.playerCount,
                t1.single_game,
                t3.total_game,
                t1.single_game/t3.total_game AS p_
         FROM
           (SELECT date, distinct_id,
                         playerCount,
                         count(DISTINCT match_id)AS single_game
            FROM events
            WHERE event = 'gameStart'
              AND gameTypeId = 1800
              AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
            GROUP BY 1,
                     2,
                     3) t1
         JOIN
           (SELECT t1.date, t1.distinct_id
            FROM
              (SELECT date, distinct_id
               FROM events
               WHERE event = 'login'
                 AND appId IN ('20014',
                               '30015')
                 AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
               GROUP BY 1,
                        2) t1
            LEFT JOIN
              (SELECT date, distinct_id
               FROM events
               WHERE event = 'register'
                 AND appId IN ('20014',
                               '30015')
                 AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
               GROUP BY 1,
                        2)t2 ON t1.distinct_id = t2.distinct_id
            AND t1.date = t2.date
            WHERE t2.distinct_id IS NULL)t2 ON t1.date = t2.date
         AND t1.distinct_id = t2.distinct_id
         JOIN
           (SELECT date, distinct_id,
                         count(DISTINCT match_id)AS total_game
            FROM events
            WHERE event = 'gameStart'
              AND gameTypeId = 1800
              AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
            GROUP BY 1,
                     2)t3 ON t2.date = t3.date
         AND t2.distinct_id = t3.distinct_id)t4)t5
   WHERE t5.rank = 1
   GROUP BY 1,
            2) t8
JOIN
  (SELECT t6.date, t6.playerCount,
                   datediff(t7.date,t6.date) AS date_gap,
                   count(t7.distinct_id)AS reten_num
   FROM
     (SELECT t5.*
      FROM
        (SELECT t4.*,
                row_number()over(partition BY t4.date,t4.distinct_id
                                 ORDER BY t4.p_ DESC)AS rank
         FROM
           (SELECT t1.date, t1.distinct_id,
                            t1.playerCount,
                            t1.single_game,
                            t3.total_game,
                            t1.single_game/t3.total_game AS p_
            FROM
              (SELECT date, distinct_id,
                            playerCount,
                            count(DISTINCT match_id)AS single_game
               FROM events
               WHERE event = 'gameStart'
                 AND gameTypeId = 1800
                 AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
               GROUP BY 1,
                        2,
                        3) t1
            JOIN
              (SELECT t1.date, t1.distinct_id
               FROM
                 (SELECT date, distinct_id
                  FROM events
                  WHERE event = 'login'
                    AND appId IN ('20014',
                                  '30015')
                    AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
                  GROUP BY 1,
                           2) t1
               LEFT JOIN
                 (SELECT date, distinct_id
                  FROM events
                  WHERE event = 'register'
                    AND appId IN ('20014',
                                  '30015')
                    AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
                  GROUP BY 1,
                           2)t2 ON t1.distinct_id = t2.distinct_id
               AND t1.date = t2.date
               WHERE t2.distinct_id IS NULL)t2 ON t1.date = t2.date
            AND t1.distinct_id = t2.distinct_id
            JOIN
              (SELECT date, distinct_id,
                            count(DISTINCT match_id)AS total_game
               FROM events
               WHERE event = 'gameStart'
                 AND gameTypeId = 1800
                 AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
               GROUP BY 1,
                        2)t3 ON t2.date = t3.date
            AND t2.distinct_id = t3.distinct_id)t4)t5
      WHERE t5.rank = 1) t6
   LEFT JOIN
     (SELECT t1.date, t1.distinct_id
      FROM
        (SELECT date, distinct_id
         FROM events
         WHERE event = 'login'
           AND appId IN ('20014',
                         '30015')
           AND date BETWEEN '2020-10-21' AND current_date()- interval 1 DAY
         GROUP BY 1,
                  2) t1
      LEFT JOIN
        (SELECT date, distinct_id
         FROM events
         WHERE event = 'register'
           AND appId IN ('20014',
                         '30015')
           AND date BETWEEN '2020-10-21' AND current_date()- interval 1 DAY
         GROUP BY 1,
                  2)t2 ON t1.distinct_id = t2.distinct_id
      AND t1.date = t2.date
      WHERE t2.distinct_id IS NULL)t7 ON t6.distinct_id = t7.distinct_id
   AND datediff(t7.date,t6.date) BETWEEN 1 AND 6
   GROUP BY 1,
            2,
            3)t9 ON t8.date = t9.date
AND t8.playerCount = t9.playerCount
ORDER BY 1,
         2,
         4