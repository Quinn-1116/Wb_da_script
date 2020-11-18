SELECT t1.hour,
       avg(t1.login_num)
FROM
  (SELECT date, hour(time)AS hour,
                count(DISTINCT distinct_id)AS login_num
   FROM events
   WHERE event = 'login'
     AND appId in('20014','30015')
     AND date BETWEEN '2020-10-20' AND '2020-11-15'
   GROUP BY 1,
            2
   ORDER BY 1,
            2)t1
GROUP BY 1
ORDER BY 1