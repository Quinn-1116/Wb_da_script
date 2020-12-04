下发任务用户数占活跃用户的比例？ - 任务覆盖率高了可能会怎样，是否需要提高覆盖率？
SELECT t1.date,
       count(t1.distinct_id)AS dau,
       count(t2.distinct_id)AS dispatch_num,
       count(t2.distinct_id)/count(t1.distinct_id)AS dispatch_rate
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'login'
     AND appId in('20014','30015')
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2) t1
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'mission'
     AND SOURCE = 'killer_dailyTask'
     AND missionOp = 'dispatch'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
GROUP BY 1
ORDER BY 1