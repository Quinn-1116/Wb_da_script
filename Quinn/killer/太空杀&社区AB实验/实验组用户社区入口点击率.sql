SELECT t1.date,
       count(t1.distinct_id),
       count(t2.distinct_id),
       count(t2.distinct_id)/count(t1.distinct_id)AS ctr
FROM
  (SELECT t1.date,
          t1.distinct_id
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'enterGameCenter'
        AND date BETWEEN '2021-02-04' AND '2021-02-11'
        AND cast(right(distinct_id,1) AS bigint)>4
        AND gameTypeId =1800
        AND appId IN ('10001',
                      '10002')
      GROUP BY 1,
               2)t1
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'enterGameCenter'
        AND date = '2021-02-04'
        AND time <='2021-02-04 11:00:00'
        AND gameTypeId =1800
        AND appId IN ('10001',
                      '10002')
      GROUP BY 1,
               2)t2 ON t1.distinct_id = t2.distinct_id
   AND t1.date = t2.date
   WHERE t2.distinct_id IS NULL
   GROUP BY 1,
            2) t1
LEFT JOIN
  (SELECT t1.date, t1.distinct_id
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'onUserClick'
        AND date BETWEEN '2021-02-04' AND '2021-02-11'
        AND button_name = 'zuiduididi'
      GROUP BY 1,
               2)t1
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'onUserClick'
        AND date = '2021-02-04'
        AND time <='2021-02-04 11:00:00'
        AND button_name = 'zuiduididi'
      GROUP BY 1,
               2)t2 ON t1.distinct_id = t2.distinct_id
   AND t1.date = t2.date
   WHERE t2.distinct_id IS NULL
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
GROUP BY 1
ORDER BY 1