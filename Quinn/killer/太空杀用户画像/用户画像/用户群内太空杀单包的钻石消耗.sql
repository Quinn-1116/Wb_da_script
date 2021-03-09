
SELECT t2.reason_diamond,
       sum(t2.amount)AS amount
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
  (SELECT distinct_id,reason_diamond,-sum(amount)AS amount
   FROM events
   WHERE event = 'addDiamond'
     AND amount <0
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
GROUP BY 1
ORDER BY 2 desc 
limit 10





SELECT t2.gameTypeId,
       sum(t2.amount)AS amount
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
  (SELECT distinct_id,gameTypeId,-sum(amount)AS amount
   FROM events
   WHERE event = 'addDiamond'
     AND amount <0
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
  where t2.gameTypeId is not null
GROUP BY 1
ORDER BY 2 desc 
limit 10