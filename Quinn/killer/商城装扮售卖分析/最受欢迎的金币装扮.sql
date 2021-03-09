SELECT t4.date,
       sum(t4.amount)
FROM
  (SELECT t1.distinct_id
   FROM
     (SELECT distinct_id
      FROM events
      WHERE event = 'pay'
        AND appId IN ('20014',
                      '30015')
        AND date BETWEEN '2020-10-31' AND '2020-12-18'
      GROUP BY 1)t1
   LEFT JOIN
     (SELECT distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('10001',
                      '10002')
        AND date BETWEEN '2020-10-31' AND '2020-12-18'
      GROUP BY 1)t2 ON t1.distinct_id = t2.distinct_id
   WHERE t2.distinct_id IS NULL) t3
LEFT JOIN
  (SELECT date,distinct_id,
               amount,
               time
   FROM events
   WHERE event = 'addDiamond'
     AND amount<0
     AND date BETWEEN '2020-10-31' AND '2020-12-18'
   GROUP BY 1,
            2,
            3,
            4)t4 ON t3.distinct_id = t4.distinct_id
GROUP BY 1
ORDER BY 1