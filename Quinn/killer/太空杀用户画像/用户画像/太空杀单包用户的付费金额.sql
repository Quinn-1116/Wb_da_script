
SELECT t1.distinct_id,
       t4.pay
FROM
  (SELECT t1.distinct_id
   FROM
     (SELECT distinct_id
      FROM user_group_user_group_tks_label_5
      GROUP BY 1)t1
   JOIN
     (SELECT distinct_id,
             appId
      FROM
        (SELECT distinct_id,
                appId,
                time,
                row_number()over(partition BY distinct_id
                                 ORDER BY time DESC)AS time_rank
         FROM events
         WHERE event = 'login'
           AND date BETWEEN '2020-12-26' AND '2021-01-25')t0
      WHERE t0.time_rank = 1
        AND t0.appId in('20014','30015')
      GROUP BY 1,
               2)t3 ON t1.distinct_id = t3.distinct_id
   GROUP BY 1)t1
JOIN
  (SELECT distinct_id,
          sum(pay)AS pay
   FROM events
   WHERE event = 'pay'
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1)t4 ON t1.distinct_id = t4.distinct_id