SELECT t3.date,
       CASE
           WHEN t3.date_gap = 0 THEN '新用户'
           WHEN t3.date_gap > 0
                AND t3.date_gap <=7 THEN '0-7天'
           WHEN t3.date_gap >7
                AND t3.date_gap <= 14 THEN '7-14天'
           WHEN t3.date_gap >14
                AND t3.date_gap <= 30 THEN '14-30天'
           WHEN t3.date_gap >30
                AND t3.date_gap <= 60 THEN '30-60天'
           WHEN t3.date_gap >60 THEN '大于60天'
       END AS "注册天数",
       count(DISTINCT t3.distinct_id)AS user_num
FROM
  (SELECT t1.date,
          datediff(t1.date,t2.reg_date)AS date_gap,
          t2.reg_date ,
          t1.distinct_id
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'mission'
        AND SOURCE = 'killer_dailyTask'
        AND missionOp = 'complete'
        AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
      GROUP BY 1,
               2) t1
   LEFT JOIN
     (SELECT second_id,
             FROM_UNIXTIME(CAST($signup_time/1000 AS BIGINT),'yyyy-MM-dd')AS reg_date
      FROM users
      WHERE second_id IS NOT NULL) t2 ON t1.distinct_id = t2.second_id)t3
GROUP BY 1,
         2
ORDER BY 1