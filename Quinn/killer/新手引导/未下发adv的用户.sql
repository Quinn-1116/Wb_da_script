SELECT t1.date,
       count(DISTINCT t1.distinct_id)AS dnu,
       count(DISTINCT t2.distinct_id)AS `次日留存用户数`
FROM
  (SELECT t1.date,
          t1.distinct_id
   FROM
     (SELECT date,distinct_id,
                  appId
      FROM events
      WHERE event = 'register'
        AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 2 DAY
        AND appId IN ('20014',
                      '30015')
      GROUP BY 1,
               2,
               3) t1
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'advSend'
        AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 2 DAY
        AND adv_id = 'b_killer_newuserlead_201217'
        AND appId IN ('20014',
                      '30015')
        AND RESULT = 'dispatch'
      GROUP BY 1,
               2)t2 ON t1.date = t2.date
   AND t1.distinct_id = t2.distinct_id
   WHERE t2.distinct_id IS NULL
   GROUP BY 1,
            2) t1
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'login'
     AND date BETWEEN '2021-01-01' AND CURRENT_DATE() - interval 1 DAY
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
AND datediff(t2.date,t1.date) = 1
GROUP BY 1
ORDER BY 1



SELECT t1.date, t1.distinct_id
FROM
  (SELECT date,distinct_id,
               appId
   FROM events
   WHERE event = 'register'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 2 DAY
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1,
            2,
            3) t1
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'advSend'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 2 DAY
     AND adv_id = 'b_killer_newuserlead_201217'
     AND appId IN ('20014',
                   '30015')
     AND RESULT = 'dispatch'
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
WHERE t2.distinct_id IS NULL
GROUP BY 1,
         2 LIMIT 1000


SELECT t1.date, count(DISTINCT t1.distinct_id),
                count(DISTINCT t2.distinct_id)
FROM
FROM
  (SELECT date,distinct_id,
               appId
   FROM events
   WHERE event = 'register'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 2 DAY
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1,
            2,
            3) t1
LEFT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'advSend'
     AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 2 DAY
     AND adv_id = 'b_killer_newuserlead_201217'
     AND appId IN ('20014',
                   '30015')
     AND RESULT = 'pop-up'
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
GROUP BY 1