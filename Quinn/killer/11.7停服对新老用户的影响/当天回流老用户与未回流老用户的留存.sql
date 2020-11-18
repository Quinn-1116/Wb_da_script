 --当天回流的老用户留存
SELECT t5.date,
       t5.`当日回流的受影响的老用户数量`,
       t7.gap,
       t7.`留存用户数`,
       t7.`留存用户数`/ t5.`当日回流的受影响的老用户数量` AS `retention`
FROM
  (SELECT t3.date,
          count(t3.distinct_id)AS `当日回流的受影响的老用户数量`
   FROM
     (SELECT t1.date,--当天登录的非首日注册用户
             t1.distinct_id
      FROM
        (SELECT date, distinct_id
         FROM events
         WHERE event = 'login'
           AND appId in('20014','30015')
           AND time BETWEEN '2020-11-07 09:00:00' AND '2020-11-07 12:00:00'
           AND date = '2020-11-07'
         GROUP BY 1,
                  2)t1
      LEFT JOIN
        (SELECT date, distinct_id
         FROM events
         WHERE event = 'register'
           AND appId in('20014','30015')
           AND date = '2020-11-07'
         GROUP BY 1,
                  2)t2 ON t1.distinct_id = t2.distinct_id
      AND t1.date = t2.date
      WHERE t2.distinct_id IS NULL
      GROUP BY 1,
               2)t3
   LEFT JOIN
     (SELECT date, distinct_id--回流的用户

      FROM events
      WHERE event = 'gameStart'
        AND gameTypeId = 1800
        AND date = '2020-11-07'
        AND time >='2020-11-07 12:00:00'
      GROUP BY 1,
               2)t4 ON t3.date = t4.date
   AND t3.distinct_id = t4.distinct_id
   WHERE t4.distinct_id IS NOT NULL
   GROUP BY 1)t5
JOIN
  (SELECT t5.date, datediff(t6.date, t5.date)AS gap,
                   count(t6.distinct_id)AS `留存用户数`
   FROM
     (SELECT t3.date, t3.distinct_id--当日回流的受到影响的老用户

      FROM
        (SELECT t1.date, t1.distinct_id--在停服期间登录的老用户

         FROM
           (SELECT date, distinct_id
            FROM events
            WHERE event = 'login'
              AND appId in('20014','30015')
              AND time BETWEEN '2020-11-07 09:00:00' AND '2020-11-07 12:00:00'
              AND date = '2020-11-07'
            GROUP BY 1,
                     2)t1
         LEFT JOIN
           (SELECT date, distinct_id
            FROM events
            WHERE event = 'register'
              AND appId in('20014','30015')
              AND date = '2020-11-07'
            GROUP BY 1,
                     2)t2 ON t1.distinct_id = t2.distinct_id
         AND t1.date = t2.date
         WHERE t2.distinct_id IS NULL
         GROUP BY 1,
                  2)t3
      LEFT JOIN
        (SELECT date, distinct_id--回流的用户

         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND date = '2020-11-07'
           AND time >='2020-11-07 12:00:00'
         GROUP BY 1,
                  2)t4 ON t3.date = t4.date
      AND t3.distinct_id = t4.distinct_id
      WHERE t4.distinct_id IS NOT NULL
      GROUP BY 1,
               2)t5
   LEFT JOIN
     (SELECT date, distinct_id--后续又进行了游戏的用户

      FROM events
      WHERE event = 'gameStart'
        AND gameTypeId = 1800
        AND date >= '2020-11-07'
      GROUP BY 1,
               2)t6 ON t5.distinct_id = t6.distinct_id
   AND datediff(t6.date,t5.date)>=1
   GROUP BY 1,
            2)t7 ON t5.date = t7.date
ORDER BY 3







 --当天未回流的老用户的留存
SELECT t5.date,
       t5.`当日未回流的受影响的老用户数量`,
       t7.gap,
       t7.`留存用户数`,
       t7.`留存用户数`/ t5.`当日未回流的受影响的老用户数量` AS `retention`
FROM
  (SELECT t3.date,
          count(t3.distinct_id)AS `当日未回流的受影响的老用户数量`
   FROM
     (SELECT t1.date,
             t1.distinct_id
      FROM
        (SELECT date, distinct_id
         FROM events
         WHERE event = 'login'
           AND appId in('20014','30015')
           AND time BETWEEN '2020-11-07 09:00:00' AND '2020-11-07 12:00:00'
           AND date = '2020-11-07'
         GROUP BY 1,
                  2)t1
      LEFT JOIN
        (SELECT date, distinct_id
         FROM events
         WHERE event = 'register'
           AND appId in('20014','30015')
           AND date = '2020-11-07'
         GROUP BY 1,
                  2)t2 ON t1.distinct_id = t2.distinct_id
      AND t1.date = t2.date
      WHERE t2.distinct_id IS NULL
      GROUP BY 1,
               2)t3
   LEFT JOIN
     (SELECT date, distinct_id--回流的用户

      FROM events
      WHERE event = 'gameStart'
        AND gameTypeId = 1800
        AND date = '2020-11-07'
        AND time >='2020-11-07 12:00:00'
      GROUP BY 1,
               2)t4 ON t3.date = t4.date
   AND t3.distinct_id = t4.distinct_id
   WHERE t4.distinct_id IS NULL
   GROUP BY 1)t5
JOIN
  (SELECT t5.date, datediff(t6.date, t5.date)AS gap,
                   count(t6.distinct_id)AS `留存用户数`
   FROM
     (SELECT t3.date, t3.distinct_id--当日未回流的受到影响的老用户

      FROM
        (SELECT t1.date, t1.distinct_id--在停服期间登录的老用户

         FROM
           (SELECT date, distinct_id
            FROM events
            WHERE event = 'login'
              AND appId in('20014','30015')
              AND time BETWEEN '2020-11-07 09:00:00' AND '2020-11-07 12:00:00'
              AND date = '2020-11-07'
            GROUP BY 1,
                     2)t1
         LEFT JOIN
           (SELECT date, distinct_id
            FROM events
            WHERE event = 'register'
              AND appId in('20014','30015')
              AND date = '2020-11-07'
            GROUP BY 1,
                     2)t2 ON t1.distinct_id = t2.distinct_id
         AND t1.date = t2.date
         WHERE t2.distinct_id IS NULL
         GROUP BY 1,
                  2)t3
      LEFT JOIN
        (SELECT date, distinct_id--回流的用户

         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND date = '2020-11-07'
           AND time >='2020-11-07 12:00:00'
         GROUP BY 1,
                  2)t4 ON t3.date = t4.date
      AND t3.distinct_id = t4.distinct_id
      WHERE t4.distinct_id IS NULL
      GROUP BY 1,
               2)t5
   LEFT JOIN
     (SELECT date, distinct_id--后续又进行了游戏的用户

      FROM events
      WHERE event = 'gameStart'
        AND gameTypeId = 1800
        AND date >= '2020-11-07'
      GROUP BY 1,
               2)t6 ON t5.distinct_id = t6.distinct_id
   AND datediff(t6.date,t5.date)>=1
   GROUP BY 1,
            2)t7 ON t5.date = t7.date
ORDER BY 3