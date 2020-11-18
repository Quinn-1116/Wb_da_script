
SELECT date, appId,
             count(distinct_id)AS `register_num`
FROM events
WHERE event = 'register'
  AND appId in('20014','30015')
  AND date = '2020-11-07'
  AND time BETWEEN '2020-11-07 09:00:00' AND '2020-11-07 12:00:00'
GROUP BY 1,
         2
ORDER BY 1