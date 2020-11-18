--回流用户：停服期间注册，停服结束后，当日有游戏行为的新注册用户
--当日回流用户的留存

SELECT t10.date,
       t10.`当日回流总人数(app回流)`,
       t20.gap,
       t20.retention,
       t20.retention/t10. `当日回流总人数(app回流)` AS `r`
FROM
  (SELECT t1.date,
          count(t1.distinct_id)AS `当日回流总人数(app回流)`
   FROM
     (SELECT date, distinct_id--停服期间的注册用户
      FROM events
      WHERE event = 'register'
        AND appId in('20014','30015')
        AND date = '2020-11-07'
        AND time BETWEEN '2020-11-07 09:00:00' AND '2020-11-07 11:59:59'
      GROUP BY 1,
               2)t1
   LEFT JOIN
     (SELECT date, distinct_id--停服后当日又登录了app的用户
      FROM events
      WHERE event = 'login'
        AND appId in('20014','30015')
        AND time > '2020-11-07 12:00:00'
        AND date = '2020-11-07'
        group by 1,2)t2 ON t1.distinct_id = t2.distinct_id
   AND t1.date = t2.date
   WHERE t2.distinct_id IS NOT NULL
   GROUP BY 1) t10
JOIN
  (SELECT t4.date, datediff(t3.date,t4.date)AS gap,
                   count(t3.distinct_id) AS retention
   FROM
     (SELECT t1.date, t1.distinct_id--当日回流用户(app回流)

      FROM
        (SELECT date, distinct_id
         FROM events
         WHERE event = 'register'
           AND appId in('20014','30015')
           AND date = '2020-11-07'
           AND time BETWEEN '2020-11-07 09:00:00' AND '2020-11-07 12:00:00'
         GROUP BY 1,
                  2)t1
      LEFT JOIN
        (SELECT date, distinct_id
         FROM events
         WHERE event = 'login'
           AND appId in('20014','30015')
           AND time > '2020-11-07 12:00:00'
           AND date = '2020-11-07'
           group by 1,2)t2 ON t1.distinct_id = t2.distinct_id
      AND t1.date = t2.date
      WHERE t2.distinct_id IS NOT NULL
      GROUP BY 1,
               2) t4
   LEFT JOIN
     (SELECT date, distinct_id--后续app留存用户

      FROM events
      WHERE event = 'login'
        AND appId IN ('20014',
                      '30015')
        AND date >= '2020-11-08'
      GROUP BY 1,
               2)t3 ON t4.distinct_id = t3.distinct_id
   AND datediff(t3.date,t4.date) BETWEEN 1 AND 7
   GROUP BY 1,
            2)t20 ON t10.date = t20.date
ORDER BY t20.gap 




--当日未回流用户的留存

SELECT t10.date,
       t10.`当日未回流总人数(app未回流)`,
       t20.gap,
       t20.retention,
       t20.retention/t10. `当日未回流总人数(app未回流)` AS `r`
FROM
  (SELECT t1.date,
          count(t1.distinct_id)AS `当日未回流总人数(app未回流)`
   FROM
     (SELECT date, distinct_id--停服期间的注册用户
      FROM events
      WHERE event = 'register'
        AND appId in('20014','30015')
        AND date = '2020-11-07'
        AND time BETWEEN '2020-11-07 09:00:00' AND '2020-11-07 11:59:59'
      GROUP BY 1,
               2)t1
   LEFT JOIN
     (SELECT date, distinct_id--停服后当日又登录了app的用户
      FROM events
      WHERE event = 'login'
        AND appId in('20014','30015')
        AND time > '2020-11-07 12:00:00'
        AND date = '2020-11-07'
        group by 1,2)t2 ON t1.distinct_id = t2.distinct_id
   AND t1.date = t2.date
   WHERE t2.distinct_id IS NULL
   GROUP BY 1) t10
JOIN
  (SELECT t4.date, datediff(t3.date,t4.date)AS gap,
                   count(t3.distinct_id) AS retention
   FROM
     (SELECT t1.date, t1.distinct_id--当日未回流用户(app未回流)

      FROM
        (SELECT date, distinct_id
         FROM events
         WHERE event = 'register'
           AND appId in('20014','30015')
           AND date = '2020-11-07'
           AND time BETWEEN '2020-11-07 09:00:00' AND '2020-11-07 12:00:00'
         GROUP BY 1,
                  2)t1
      LEFT JOIN
        (SELECT date, distinct_id
         FROM events
         WHERE event = 'login'
           AND appId in('20014','30015')
           AND time > '2020-11-07 12:00:00'
           AND date = '2020-11-07'
           group by 1,2)t2 ON t1.distinct_id = t2.distinct_id
      AND t1.date = t2.date
      WHERE t2.distinct_id IS NULL
      GROUP BY 1,
               2) t4
   LEFT JOIN
     (SELECT date, distinct_id--后续app留存用户

      FROM events
      WHERE event = 'login'
        AND appId IN ('20014',
                      '30015')
        AND date >= '2020-11-08'
      GROUP BY 1,
               2)t3 ON t4.distinct_id = t3.distinct_id
   AND datediff(t3.date,t4.date) BETWEEN 1 AND 7
   GROUP BY 1,
            2)t20 ON t10.date = t20.date
ORDER BY t20.gap 