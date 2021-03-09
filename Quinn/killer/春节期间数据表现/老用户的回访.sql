
SELECT t1.date,
       count(t1.distinct_id),
       count(t2.distinct_id),
       count(t2.distinct_id)/count(t1.distinct_id)AS `回访`
FROM
  (SELECT t1.date,
          t1.distinct_id
   FROM
     (SELECT date, distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('20014',
                      '30015')
        AND date BETWEEN '2021-02-01' AND current_date()
      GROUP BY 1,
               2) t1
   LEFT JOIN
     (SELECT date, distinct_id
      FROM events
      WHERE event = 'register'
        AND appId IN ('20014',
                      '30015')
        AND date BETWEEN '2021-02-01' AND current_date()
      GROUP BY 1,
               2)t2 ON t1.distinct_id = t2.distinct_id
   AND t1.date = t2.date
   WHERE t2.distinct_id IS NULL
   GROUP BY 1,
            2)t1
LEFT JOIN
  (SELECT date, distinct_id
   FROM events
   WHERE event = 'login'
     AND appId IN ('20014',
                   '30015')
     AND date BETWEEN '2021-02-01' AND current_date()
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
AND datediff(t2.date,t1.date) = 1
GROUP BY 1
ORDER BY 1