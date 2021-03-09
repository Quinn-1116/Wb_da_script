SELECT t3.date,
       count(t3.distinct_id)
FROM
  (SELECT date, distinct_id
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
   GROUP BY 1,
            2) t3
JOIN
  (SELECT t1.date, t1.distinct_id
   FROM
     (SELECT date, distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('20014',
                      '30015')
        AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
      GROUP BY 1,
               2) t1
   LEFT JOIN
     (SELECT date, distinct_id
      FROM events
      WHERE event = 'register'
        AND appId IN ('20014',
                      '30015')
        AND date BETWEEN '2020-10-20' AND current_date()- interval 2 DAY
      GROUP BY 1,
               2)t2 ON t1.distinct_id = t2.distinct_id
   AND t1.date = t2.date
   WHERE t2.distinct_id IS NULL)t4 ON t3.distinct_id = t4.distinct_id
AND t3.date = t4.date
GROUP BY 1
ORDER BY 1