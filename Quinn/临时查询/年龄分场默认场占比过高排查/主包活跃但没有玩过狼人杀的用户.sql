SELECT t1.distinct_id,
       t1.`最近一周登录天数`
FROM
  (SELECT distinct_id,
          count(DISTINCT date) AS `最近一周登录天数`
   FROM events
   WHERE event = 'login'
     AND appId in('10001','10002')
     AND date BETWEEN current_date() - interval 7 DAY AND current_date()
   GROUP BY 1 HAVING count(DISTINCT date) >=5) t1
LEFT JOIN
  (SELECT distinct_id
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-10-16' AND current_date()
   GROUP BY 1)t2 ON t1.distinct_id = t2.distinct_id
WHERE t2.distinct_id IS NULL
GROUP BY 1,
         2