--新用户留存
SELECT t40.*,
       t50.*,
       t50.reten_num/t40.game_num
FROM
  (SELECT t30.date,
          t30.playerCount,
          count(t30.distinct_id) AS game_num
   FROM
     (SELECT t2.*,
             t3.total_game_num,
             t2.game_num/t3.total_game_num AS p_
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
                     count(distinct_id)AS total_game_num
         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
         GROUP BY 1,
                  2)t3 ON t1.date = t3.date
      AND t1.distinct_id = t3.distinct_id HAVING t2.game_num/t3.total_game_num >= 0.5)t30
   GROUP BY 1,
            2) t40
JOIN
  (SELECT t10.date, t10.playerCount,
                    datediff(t20.date,t10.date)AS date_gap,
                    count(t20.distinct_id)AS reten_num
   FROM
     (SELECT t2.*,
             t3.total_game_num,
             t2.game_num/t3.total_game_num AS p_
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
                      '30015')
        AND date BETWEEN '2020-10-21' AND current_date()- interval 1 DAY
      GROUP BY 1,
               2) t20 ON t10.distinct_id = t20.distinct_id
   AND datediff(t20.date,t10.date) BETWEEN 1 AND 6
   GROUP BY 1,
            2,
            3)t50 ON t40.date = t50.date
AND t40.playerCount = t50.playerCount
ORDER BY t50.date, t50.playerCount,
                   t50.date_gap








