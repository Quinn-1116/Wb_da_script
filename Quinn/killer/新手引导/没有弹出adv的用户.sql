
SELECT t1.date,
       t1.appId,
       t1.distinct_id
FROM
  (SELECT date,distinct_id,
               appId
   FROM events
   WHERE event = 'register'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 1 DAY
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1,
            2,
            3) t1
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'advSend'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 1 DAY
     AND adv_id = 'b_killer_newuserlead_201217'
     AND appId IN ('20014',
                   '30015')
     AND RESULT = 'pop-up'
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
WHERE t2.distinct_id IS NULL 