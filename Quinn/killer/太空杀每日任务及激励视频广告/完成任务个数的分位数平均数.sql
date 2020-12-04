SELECT t2.*
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'login'
     AND appId IN ('20014',
                   '30015')
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t1
JOIN
  (SELECT date,distinct_id,
               count(distinct_id)AS finish_num
   FROM events
   WHERE event = 'mission'
     AND SOURCE = 'killer_dailyTask'
     AND missionOp = 'finish'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id