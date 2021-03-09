--太空杀收入
 --太空杀单包充值金额

SELECT date,sum(pay)AS pay
FROM events
WHERE event = 'pay'
  AND appId IN ('20014',
                '30015')
  AND date = current_date() - interval 1 DAY
GROUP BY 1
SELECT t2.date, sum(t2.killer_store_diamond)/10 AS pay
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'login'
     AND appId IN ('10001',
                   '10002',
                   '20009')
     AND date = current_date() - interval 1 DAY
   GROUP BY 1,
            2) t1
JOIN
  (SELECT date,distinct_id,
               sum(amount) AS killer_store_diamond
   FROM events
   WHERE event = 'exchange'
     AND currency_type = 'diamond'
     AND tag_id IN (1153,
                    1154,
                    1155,
                    1156,
                    1158,
                    1160,
                    1161,
                    1165,
                    1180,
                    1181,
                    1183,
                    1188,
                    1189,
                    1190)
     AND date = current_date() - interval 1 DAY
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
GROUP BY 1
SELECT t2.date,sum(t2.killer_activity_diamond)/ 10 AS pay
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'login'
     AND appId IN ('10001',
                   '10002',
                   '20009')
     AND date = current_date() - interval 1 DAY
   GROUP BY 1,
            2) t1
JOIN
  (SELECT date,distinct_id, -sum(amount) AS killer_activity_diamond
   FROM events
   WHERE event = 'addDiamond'
     AND amount <0
     AND reason_diamond LIKE '%killer%'
     AND date = current_date() - interval 1 DAY
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
GROUP BY 1 


--狼人杀收入
--撞王收入
