
SELECT t1.date,
       count(DISTINCT t1.distinct_id)AS dnu,
       count(DISTINCT t2.distinct_id)AS `弹窗下发`,
       count(DISTINCT t2.distinct_id)/ count(DISTINCT t1.distinct_id)AS p1,
       count(DISTINCT t3.distinct_id)AS `弹窗弹出`,
       count(DISTINCT t3.distinct_id)/count(DISTINCT t2.distinct_id)AS p2
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'register'
     AND date BETWEEN '2021-01-15' AND CURRENT_DATE() - interval 1 DAY
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1,
            2) t1
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'advSend'
     AND date BETWEEN '2021-01-15' AND CURRENT_DATE() - interval 1 DAY
     AND adv_id = 'b_killer_newuserlead_201217'
     AND appId IN ('20014',
                   '30015')
     AND RESULT = 'dispatch'
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'advSend'
     AND date BETWEEN '2021-01-15' AND CURRENT_DATE() - interval 1 DAY
     AND adv_id = 'b_killer_newuserlead_201217'
     AND appId IN ('20014',
                   '30015')
     AND RESULT = 'pop-up'
   GROUP BY 1,
            2)t3 ON t1.date = t3.date
AND t1.distinct_id = t3.distinct_id
AND t2.distinct_id = t3.distinct_id
GROUP BY 1
ORDER BY 1