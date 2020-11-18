SELECT t1.date,
       count(t1.distinct_id)AS `停服期间登录的老用户数`
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
GROUP BY 1






SELECT t1.date, count(t1.distinct_id)AS `停服当天登录的老用户数`
FROM
  (SELECT date, distinct_id
   FROM events
   WHERE event = 'login'
     AND appId in('20014','30015')
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
GROUP BY 1



