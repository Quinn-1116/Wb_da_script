
  (SELECT date,distinct_id,
               count(distinct_id)AS finish_num
   FROM events
   WHERE event = 'mission'
     AND SOURCE = 'killer_dailyTask'
     AND missionOp = 'finish'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2) t2
LEFT JOIN
  (SELECT date,distinct_id,
               count(distinct_id)AS completed_num
   FROM events
   WHERE event = 'mission'
     AND SOURCE = 'killer_dailyTask'
     AND missionOp = 'complete'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2) t3 ON t2.date = t3.date
AND t2.distinct_id = t3.distinct_id