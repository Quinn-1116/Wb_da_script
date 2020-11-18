--当天回流的老用户
SELECT t3.date,
       count(t3.distinct_id),
       count(t4.distinct_id),
       count(t4.distinct_id)/count(t3.distinct_id)AS r1
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
  (SELECT date, distinct_id
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND date = '2020-11-07'
     AND time >='2020-11-07 12:00:00'
   GROUP BY 1,
            2)t4 ON t3.date = t4.date
AND t3.distinct_id = t4.distinct_id
GROUP BY 1