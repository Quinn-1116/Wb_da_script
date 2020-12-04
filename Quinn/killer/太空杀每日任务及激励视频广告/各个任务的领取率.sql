SELECT t1.date,
       CASE
           WHEN t1.missionId = 70007 THEN 'finish_killer_3'
           WHEN t1.missionId = 70008 THEN 'finish_killer_5'
           WHEN t1.missionId = 70009 THEN 'finish_10'
           WHEN t1.missionId = 70010 THEN 'finish_15'
           WHEN t1.missionId = 70011 THEN 'impostor_2'
           WHEN t1.missionId = 70012 THEN 'impostor_3'
           WHEN t1.missionId = 70013 THEN 'crew_victory_4'
           WHEN t1.missionId = 70014 THEN 'impostor_victory_2'
           WHEN t1.missionId = 70015 THEN 'win_10'
           WHEN t1.missionId = 70016 THEN 'win_15'
           WHEN t1.missionId = 70017 THEN 'finish_task'
           WHEN t1.missionId = 70018 THEN 'finish_emergency_task'
           WHEN t1.missionId = 70019 THEN 'report_1'
           WHEN t1.missionId = 70020 THEN 'meeting_1'
           WHEN t1.missionId = 70021 THEN 'kill_3'
           WHEN t1.missionId = 70022 THEN 'break_3'
           WHEN t1.missionId = 70023 THEN 'addfriend_1'
           WHEN t1.missionId = 70024 THEN 'addfriend_3'
           WHEN t1.missionId = 70025 THEN 'buy_1'
           WHEN t1.missionId = 70026 THEN 'buy_2'
       END AS task_type,
       count(t1.distinct_id)AS dispatch_num,
       count(t2.distinct_id)AS finish_num,
       count(t2.distinct_id)/count(t1.distinct_id) AS finish_rate,
       count(t3.distinct_id)AS complete_num,
       count(t3.distinct_id)/count(t2.distinct_id) AS complete_rate
FROM
  (SELECT date,distinct_id,
               missionId
   FROM events
   WHERE event = 'mission'
     AND SOURCE = 'killer_dailyTask'
     AND missionOp = 'dispatch'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2,
            3)t1
LEFT JOIN
  (SELECT date,distinct_id,
               missionId
   FROM events
   WHERE event = 'mission'
     AND SOURCE = 'killer_dailyTask'
     AND missionOp = 'finish'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2,
            3)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
AND t1.missionId = t2.missionId
LEFT JOIN
  (SELECT date,distinct_id,
               missionId
   FROM events
   WHERE event = 'mission'
     AND SOURCE = 'killer_dailyTask'
     AND missionOp = 'complete'
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2,
            3)t3 ON t2.date = t3.date
AND t2.distinct_id = t3.distinct_id
AND t2.missionId = t3.missionId
GROUP BY 1,
         2
ORDER BY 1,
         2