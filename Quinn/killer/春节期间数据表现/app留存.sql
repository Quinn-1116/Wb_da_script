
SELECT t1.date,
       count(t2.distinct_id)/ count(t1.distinct_id) AS app_r1
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'register'
     AND appId IN ('20014',
                   '30015')
     AND date BETWEEN '2021-01-28' AND '2021-03-01'
   GROUP BY 1,
            2)t1
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'login'
     AND appId IN ('20014',
                   '30015')
     AND date BETWEEN '2021-01-28' AND '2021-03-01'
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
AND datediff(t2.date,t1.date) = 1
GROUP BY 1
ORDER BY 1