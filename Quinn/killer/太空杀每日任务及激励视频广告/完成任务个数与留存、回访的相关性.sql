SELECT t3.date,
       t3.finish_num,
       t3.user_num,
       t5.date_gap,
       t5.reten_num,
       t5.reten_num/t3.user_num AS retention
FROM
  (SELECT t1.date,--完成不同个数任务的用户量
          t2.finish_num,
          count(t1.distinct_id) AS user_num
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'register'
        AND appId IN ('20014',
                      '30015')
        AND date BETWEEN '2020-11-20' AND current_date() - interval 2 DAY
      GROUP BY 1,
               2) t1
   JOIN
     (SELECT date,distinct_id,
                  count(distinct_id)AS finish_num
      FROM events
      WHERE event = 'mission'
        AND SOURCE = 'killer_dailyTask'
        AND missionOp = 'finish'
        AND date BETWEEN '2020-11-20' AND current_date() - interval 2 DAY
      GROUP BY 1,
               2)t2 ON t1.date = t2.date
   AND t1.distinct_id =t2.distinct_id
   GROUP BY 1,
            2) t3
JOIN
  (SELECT t3.date, datediff(t4.date,t3.date)AS date_gap,
                   t3.finish_num,
                   count(t3.distinct_id),
                   count(t4.distinct_id)AS reten_num
   FROM
     (SELECT t2.*
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'register'
           AND appId IN ('20014',
                         '30015')
           AND date BETWEEN '2020-11-20' AND current_date() - interval 2 DAY
         GROUP BY 1,
                  2) t1
      JOIN
        (SELECT date,distinct_id,
                     count(distinct_id)AS finish_num
         FROM events
         WHERE event = 'mission'
           AND SOURCE = 'killer_dailyTask'
           AND missionOp = 'finish'
           AND date BETWEEN '2020-11-20' AND current_date() - interval 2 DAY
         GROUP BY 1,
                  2)t2 ON t1.date = t2.date
      AND t1.distinct_id =t2.distinct_id) t3
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('20014',
                      '30015')
        AND date BETWEEN '2020-11-21' AND current_date() - interval 1 DAY
      GROUP BY 1,
               2)t4 ON t3.distinct_id = t4.distinct_id
   AND datediff(t4.date,t3.date) BETWEEN 1 AND 6
   GROUP BY 1,
            2,
            3)t5 ON t3.date = t5.date
AND t3.finish_num = t5.finish_num
ORDER BY 1,
         2,
         4



--完成不同个数的任务对回访的影响
SELECT t3.date,
       t3.finish_num,
       t3.user_num,
       t5.date_gap,
       t5.reten_num,
       t5.reten_num/t3.user_num AS retention
FROM
  (SELECT t9.date,
          t2.finish_num,
          count(t9.distinct_id) AS user_num
   FROM
     (SELECT t7.date,
             t7.distinct_id
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'login'
           AND appId in('20014','30015')
           AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2) t7
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'register'
           AND appId in('20014','30015')
           AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t8 ON t7.date = t8.date
      AND t7.distinct_id = t8.distinct_id
      WHERE t8.distinct_id IS NULL
      GROUP BY 1,
               2)t9
   JOIN
     (SELECT date,distinct_id,
                  count(distinct_id)AS finish_num
      FROM events
      WHERE event = 'mission'
        AND SOURCE = 'killer_dailyTask'
        AND missionOp = 'finish'
        AND date BETWEEN '2020-11-20' AND current_date() - interval 2 DAY
      GROUP BY 1,
               2)t2 ON t9.date = t2.date
   AND t9.distinct_id =t2.distinct_id
   GROUP BY 1,
            2) t3
JOIN
  (SELECT t3.date, datediff(t4.date,t3.date)AS date_gap,
                   t3.finish_num,
                   count(t3.distinct_id),
                   count(t4.distinct_id)AS reten_num
   FROM
     (SELECT t2.*
      FROM
        (SELECT t7.date, t7.distinct_id--当日登录的老用户
         FROM
           (SELECT date,distinct_id
            FROM events
            WHERE event = 'login'
              AND appId in('20014','30015')
              AND date BETWEEN '2020-11-20' AND current_date() - interval 2 DAY
            GROUP BY 1,
                     2) t7
         LEFT JOIN
           (SELECT date,distinct_id
            FROM events
            WHERE event = 'register'
              AND appId in('20014','30015')
              AND date BETWEEN '2020-11-20' AND current_date() - interval 2 DAY
            GROUP BY 1,
                     2)t8 ON t7.date = t8.date
         AND t7.distinct_id = t8.distinct_id
         WHERE t8.distinct_id IS NULL
         GROUP BY 1,
                  2) t1
      JOIN
        (SELECT date,distinct_id,--完成不同个数的用户
                     count(distinct_id)AS finish_num
         FROM events
         WHERE event = 'mission'
           AND SOURCE = 'killer_dailyTask'
           AND missionOp = 'finish'
           AND date BETWEEN '2020-11-20' AND current_date() - interval 2 DAY
         GROUP BY 1,
                  2)t2 ON t1.date = t2.date
      AND t1.distinct_id =t2.distinct_id) t3
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('20014',
                      '30015')
        AND date BETWEEN '2020-11-21' AND current_date() - interval 1 DAY
      GROUP BY 1,
               2)t4 ON t3.distinct_id = t4.distinct_id
   AND datediff(t4.date,t3.date) BETWEEN 1 AND 6
   GROUP BY 1,
            2,
            3)t5 ON t3.date = t5.date
AND t3.finish_num = t5.finish_num
ORDER BY 1,
         2,
         4