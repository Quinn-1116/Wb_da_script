SELECT t1.distinct_id,
       t2.reg_date,
       t3.time AS first_pay_time,
       t4.pay AS last_month_total_pay,
       t5.killer_game_num,
       t5.killer_game_duration,
       t6.killer_with_friend_num,
       t7.friend_num,
       t8.dia_amount,
       t9.killer_diamond,
       t10.gift_amount
FROM
  (SELECT distinct_id
   FROM user_group_user_group_tks_label_5
   GROUP BY 1)t1
LEFT JOIN
  (SELECT second_id,
          FROM_UNIXTIME(CAST($signup_time/1000 AS BIGINT))AS reg_date
   FROM users
   WHERE second_id IS NOT NULL
     AND user_group_tks_label_5 = 1)t2 ON t1.distinct_id = t2.second_id
LEFT JOIN
  (SELECT distinct_id,
          time
   FROM
     (SELECT distinct_id,
             time,
             row_number()over(partition BY distinct_id
                              ORDER BY time)AS time_rank
      FROM events
      WHERE event = 'pay'
        AND date BETWEEN '2017-01-01' AND '2021-01-25')AS temp_t
   WHERE temp_t.time_rank = 1)t3 ON t1.distinct_id = t3.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          sum(pay)AS pay
   FROM events
   WHERE event = 'pay'
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1)t4 ON t1.distinct_id = t4.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          count(distinct_id)AS killer_game_num,
          sum(duration)/60000 AS killer_game_duration
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1)t5 ON t1.distinct_id = t5.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          count(match_id)AS killer_with_friend_num
   FROM events
   WHERE event = 'gameOver'
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
     AND gameTypeId = 1800
     AND friends != ''
   GROUP BY 1)t6 ON t1.distinct_id = t6.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          count(distinct_id)AS friend_num
   FROM EVENTS
   WHERE event = 'addFriendNew'
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1)t7 ON t1.distinct_id = t7.distinct_id
LEFT JOIN
  (SELECT distinct_id, -sum(amount) AS dia_amount
   FROM EVENTS
   WHERE event = 'addDiamond'
     AND amount <0
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1)t8 ON t1.distinct_id = t8.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          sum(killer_diamond)AS killer_diamond
   FROM
     (SELECT distinct_id,
             sum(amount) AS killer_diamond
      FROM events
      WHERE event = 'exchange'
        AND currency_type = 'diamond'
        AND tag_id IN (1153,
                       1154,
                       1155,
                       1156,
                       1158,
                       1160,
                       1161,
                       1165,
                       1180,
                       1181,
                       1183)
        AND date BETWEEN '2020-12-26' AND '2021-01-25'
      GROUP BY 1
      UNION ALL SELECT distinct_id,-sum(amount)AS killer_diamond
      FROM events
      WHERE event = 'addDiamond'
        AND reason_diamond LIKE '%killer%'
        AND date BETWEEN '2020-12-26' AND '2021-01-25'
      GROUP BY 1)t0
   GROUP BY 1)t9 ON t1.distinct_id = t9.distinct_id
LEFT JOIN
  (SELECT distinct_id, -sum(amount) AS gift_amount
   FROM EVENTS
   WHERE event = 'addDiamond'
     AND amount <0
     AND gameTypeId = 2000
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1)t10 ON t1.distinct_id=t10.distinct_id