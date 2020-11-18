--当天回流的老用户

SELECT t10.date,
       t10.all_user,
       t20.gap,
       t20.retention,
       t20.retention/t10.all_user AS r
FROM
  (SELECT t1.date,
          count(DISTINCT t1.distinct_id)AS all_user
   FROM
     (SELECT date, distinct_id
      FROM events
      WHERE event = 'login'
        AND appId in('20014','30015')
        AND time BETWEEN '2020-10-31 09:00:00' AND '2020-10-31 12:00:00'
        AND date = '2020-10-31'
      GROUP BY 1,
               2)t1
   LEFT JOIN
     (SELECT date, distinct_id
      FROM events
      WHERE event = 'register'
        AND appId in('20014','30015')
        AND date = '2020-10-31'
      GROUP BY 1,
               2)t2 ON t1.distinct_id = t2.distinct_id
   AND t1.date = t2.date
   WHERE t2.distinct_id IS NULL
   GROUP BY 1) t10
JOIN
  (SELECT t3.date, datediff(t4.date,t3.date)AS gap,
                   count(t4.distinct_id)AS retention
   FROM
     (SELECT t1.date, t1.distinct_id
      FROM
        (SELECT date, distinct_id
         FROM events
         WHERE event = 'login'
           AND appId in('20014','30015')
           AND time BETWEEN '2020-10-31 09:00:00' AND '2020-10-31 12:00:00'
           AND date = '2020-10-31'
         GROUP BY 1,
                  2)t1
      LEFT JOIN
        (SELECT date, distinct_id
         FROM events
         WHERE event = 'register'
           AND appId in('20014','30015')
           AND date = '2020-10-31'
         GROUP BY 1,
                  2)t2 ON t1.distinct_id = t2.distinct_id
      AND t1.date = t2.date
      WHERE t2.distinct_id IS NULL
      GROUP BY 1,
               2)t3
   LEFT JOIN
     (SELECT date, distinct_id
      FROM events
      WHERE event = 'login'
        AND appId in('20014','30015')
        AND date > '2020-10-31'
      GROUP BY 1,
               2)t4 ON datediff(t4.date,t3.date) BETWEEN 1 AND 7
   AND t3.distinct_id = t4.distinct_id
   GROUP BY 1,
            2)t20 ON t10.date = t20.date
ORDER BY 3