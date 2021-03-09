
SELECT t1.date,
       count(t1.distinct_id)AS `主包日活`,
       count(t2.distinct_id)AS `主包太空杀用户`,
       count(t2.distinct_id)/count(t1.distinct_id)AS `太空杀主包渗透率`
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'login'
     AND appId IN ('10001',
                   '10002')
     AND date BETWEEN '2021-01-28' AND '2021-02-28'
   GROUP BY 1,
            2) t1
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND appId IN ('10001',
                   '10002')
     AND date BETWEEN '2021-01-28' AND '2021-02-28'
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
AND t1.date = t2.date
GROUP BY 1
ORDER BY 1