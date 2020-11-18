11.14 9-12点的留存 11.14 9-12点的留存 11.14 9-12点的留存 --当天回流的老用户留存


SELECT t1.date,
       t1.`受影响的新注册用户量`,
       t4.gap,
       t4.retention,
       t4.retention/t1.`受影响的新注册用户量` as r
FROM
  (SELECT date, count(DISTINCT distinct_id)AS `受影响的新注册用户量`
   FROM events
   WHERE event = 'register'
     AND appId in('20014','30015')
     AND date = '2020-11-14'
     AND time BETWEEN '2020-11-14 09:00:00' AND '2020-11-14 12:00:00'
   GROUP BY 1)t1
JOIN
  (SELECT t2.date, datediff(t3.date,t2.date)AS gap,
                   count(t3.distinct_id) AS retention
   FROM
     (SELECT date, distinct_id
      FROM events
      WHERE event = 'register'
        AND appId in('20014','30015')
        AND date = '2020-11-14'
        AND time BETWEEN '2020-11-14 09:00:00' AND '2020-11-14 12:00:00'
      GROUP BY 1,
               2)t2
   LEFT JOIN
     (SELECT date, distinct_id--后续留存用户
      FROM events
      WHERE event = 'login'
        AND date >= '2020-11-14'
      GROUP BY 1,
               2)t3 ON t3.distinct_id = t2.distinct_id
   AND datediff(t3.date,t2.date) BETWEEN 1 AND 7
   GROUP BY 1,
            2)t4 ON t1.date = t4.date
  order by 3





  SELECT t1.date,
       t1.`受影响的新注册用户量`,
       t4.gap,
       t4.retention,
       t4.retention/t1.`受影响的新注册用户量` AS r
FROM
  (SELECT date, count(DISTINCT distinct_id)AS `受影响的新注册用户量`
   FROM events
   WHERE event = 'register'
     AND appId in('20014','30015')
     AND date = '2020-10-31'
     AND time BETWEEN '2020-10-31 09:00:00' AND '2020-10-31 12:00:00'
   GROUP BY 1)t1
JOIN
  (SELECT t2.date, datediff(t3.date,t2.date)AS gap,
                   count(t3.distinct_id) AS retention
   FROM
     (SELECT date, distinct_id
      FROM events
      WHERE event = 'register'
        AND appId in('20014','30015')
        AND date = '2020-10-31'
        AND time BETWEEN '2020-10-31 09:00:00' AND '2020-10-31 12:00:00'
      GROUP BY 1,
               2)t2
   LEFT JOIN
     (SELECT date, distinct_id--后续游戏留存用户
      FROM events
      WHERE event = 'gameStart'
        AND gameTypeId = 1800
        AND date >= '2020-10-31'
      GROUP BY 1,
               2)t3 ON t3.distinct_id = t2.distinct_id
   AND datediff(t3.date,t2.date) BETWEEN 1 AND 7
   GROUP BY 1,
            2)t4 ON t1.date = t4.date
ORDER BY 3