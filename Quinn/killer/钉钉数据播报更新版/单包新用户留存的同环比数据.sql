
SELECT t4.date,
       t4.r1,
       t4.r1-t4.r11 AS day_r1,
       t4.r1- t4.r71 AS week_r1
FROM
  (SELECT t3.date,
          t3.r1,
          lead(t3.r1,1) over(
                             ORDER BY t3.date DESC) AS r11 ,
          lead(t3.r1,7) over(
                             ORDER BY t3.date DESC) AS r71
   FROM
     (SELECT t1.date,
             count(t2.distinct_id)/count(t1.distinct_id) AS r1
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'register'
           AND appId in('30015','20014')
           AND date BETWEEN current_date() - interval 9 DAY AND current_date() - interval 2 DAY
         GROUP BY 1,
                  2)t1
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'login'
           AND appId in('30015','20014')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t2 ON t1.distinct_id = t2.distinct_id
      AND datediff(t2.date,t1.date) = 1
      GROUP BY 1) t3 LIMIT 1)t4





SELECT t4.date,
       t4.r1,
       t4.r1-t4.r11 AS day_r1,
       t4.r1- t4.r71 AS week_r1
FROM
  (SELECT t3.date,
          t3.r1,
          lead(t3.r1,1) over(
                             ORDER BY t3.date DESC) AS r11 ,
          lead(t3.r1,7) over(
                             ORDER BY t3.date DESC) AS r71
   FROM
     (SELECT t1.date,
             count(t2.distinct_id)/count(t1.distinct_id) AS r1
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'register'
           AND appId in('20014')
           AND date BETWEEN current_date() - interval 9 DAY AND current_date() - interval 2 DAY
         GROUP BY 1,
                  2)t1
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'login'
           AND appId in('20014')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t2 ON t1.distinct_id = t2.distinct_id
      AND datediff(t2.date,t1.date) = 1
      GROUP BY 1) t3 LIMIT 1)t4




SELECT t4.date,
       t4.r1,
       t4.r1-t4.r11 AS day_r1,
       t4.r1- t4.r71 AS week_r1
FROM
  (SELECT t3.date,
          t3.r1,
          lead(t3.r1,1) over(
                             ORDER BY t3.date DESC) AS r11 ,
          lead(t3.r1,7) over(
                             ORDER BY t3.date DESC) AS r71
   FROM
     (SELECT t1.date,
             count(t2.distinct_id)/count(t1.distinct_id) AS r1
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'register'
           AND appId in('30015')
           AND date BETWEEN current_date() - interval 9 DAY AND current_date() - interval 2 DAY
         GROUP BY 1,
                  2)t1
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'login'
           AND appId in('30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t2 ON t1.distinct_id = t2.distinct_id
      AND datediff(t2.date,t1.date) = 1
      GROUP BY 1) t3 LIMIT 1)t4