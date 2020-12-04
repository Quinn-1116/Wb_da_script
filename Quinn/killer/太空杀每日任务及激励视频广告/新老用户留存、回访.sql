SELECT t3.date,
       t3.dnu,
       t4.date_gap,
       t4.reten_num,
       t4.reten_num/t3.dnu AS retention
FROM
  (SELECT date,count(DISTINCT distinct_id) AS dnu
   FROM events
   WHERE event = 'register'
     AND appId IN ('20014',
                   '30015')
     AND date BETWEEN '2020-11-20' AND current_date() - interval 1 DAY
   GROUP BY 1) t3
LEFT JOIN
  (SELECT t1.date, datediff(t2.date,t1.date)date_gap,
                   count(t2.distinct_id)AS reten_num
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'register'
        AND appId IN ('20014',
                      '30015')
        AND date BETWEEN '2020-11-20' AND current_date() - interval 2 DAY
      GROUP BY 1,
               2) t1
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('20014',
                      '30015')
        AND date BETWEEN '2020-11-21' AND current_date() - interval 1 DAY
      GROUP BY 1,
               2)t2 ON t1.distinct_id = t2.distinct_id
   AND datediff(t2.date,t1.date) BETWEEN 1 AND 6
   GROUP BY 1,
            2)t4 ON t3.date = t4.date
ORDER BY 1,
         3