
SELECT t2.distinct_id,
       t2.min
FROM
  (SELECT t1.distinct_id
   FROM
     (SELECT distinct_id
      FROM user_group_user_group_tks_label_7
      GROUP BY 1)t1
   JOIN
     (SELECT distinct_id
      FROM
        (SELECT distinct_id, appId, time, date, row_number()over(partition BY distinct_id
                                                                 ORDER BY time DESC)AS time_rank
         FROM events
         WHERE event = 'login'
           AND date BETWEEN '2020-12-26' AND '2021-01-25'
           AND appId IN ('20014',
                         '30015'))t0
      WHERE t0.time_rank = 1)t3 ON t1.distinct_id = t3.distinct_id)t1
JOIN
  (SELECT distinct_id,
          sum(duration)/60 MIN
   FROM events
   WHERE event = 'roomExit'
     AND gameTypeId = 2000
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1) t2 ON t1.distinct_id = t2.distinct_id 