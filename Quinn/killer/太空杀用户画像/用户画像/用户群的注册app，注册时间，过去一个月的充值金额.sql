 -- 用户群的注册app，注册时间，首次充值时间，充值频次，充值金额

SELECT t3.appId,
       count(t1.distinct_id)AS user_num
FROM
  (SELECT distinct_id
   FROM user_group_user_group_tks_label_5
   GROUP BY 1)t1
LEFT JOIN
  (SELECT second_id,
          FROM_UNIXTIME(CAST($signup_time/1000 AS BIGINT))AS reg_time,
          reg_gender,
          reg_appId
   FROM users
   WHERE second_id IS NOT NULL
     AND $signup_time IS NOT NULL)t2 ON t1.distinct_id = t2.second_id
LEFT JOIN
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
   GROUP BY 1,
            2)t3 ON t1.distinct_id = t3.distinct_id
GROUP BY 1
ORDER BY 2 DESC --注册appId

SELECT t2.reg_appId,
       count(t1.distinct_id)AS user_num
FROM
  (SELECT distinct_id
   FROM user_group_user_group_tks_label_5
   GROUP BY 1)t1
LEFT JOIN
  (SELECT second_id,
          FROM_UNIXTIME(CAST($signup_time/1000 AS BIGINT))AS reg_time,
          reg_gender,
          reg_appId
   FROM users
   WHERE second_id IS NOT NULL
     AND $signup_time IS NOT NULL)t2 ON t1.distinct_id = t2.second_id
LEFT JOIN
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
   GROUP BY 1,
            2)t3 ON t1.distinct_id = t3.distinct_id
GROUP BY 1
ORDER BY 2 DESC

