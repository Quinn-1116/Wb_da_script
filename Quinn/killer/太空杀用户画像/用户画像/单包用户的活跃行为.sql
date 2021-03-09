
SELECT t1.distinct_id,
       t2.game_num,
       t4.killer_with_friend_num,
       t5.friend_num,
       t6.new_num,
       t6.duomaomao_num,
       t6.advance_num,
       t6.twelve_num,
       t6.duomaomao2_num,
       t7.MIN,
       t8.total_pay
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
LEFT JOIN
  (SELECT distinct_id,
          count(distinct_id)AS game_num
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1) t2 ON t1.distinct_id = t2.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          count(match_id)AS killer_with_friend_num
   FROM events
   WHERE event = 'gameOver'
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
     AND gameTypeId = 1800
     AND friends != ''
   GROUP BY 1)t4 ON t1.distinct_id = t4.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          count(distinct_id)AS friend_num
   FROM EVENTS
   WHERE event = 'addFriendNew'
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1)t5 ON t1.distinct_id = t5.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          count(distinct_id)AS total_num,
          count(if(gameSubtype = '1',1,NULL))AS new_num,
          count(if(gameSubtype = '2',1,NULL))AS duomaomao_num,
          count(if(gameSubtype = '3',1,NULL))AS advance_num,
          count(if(gameSubtype = '4',1,NULL))AS twelve_num,
          count(if(gameSubtype = '5',1,NULL))AS duomaomao2_num
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1)t6 ON t1.distinct_id = t6.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          sum(duration)/60 MIN
   FROM events
   WHERE event = 'roomExit'
     AND gameTypeId = 2000
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1) t7 ON t1.distinct_id = t7.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          sum(pay) AS total_pay
   FROM events
   WHERE event = 'pay'
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1)t8 ON t1.distinct_id = t8.distinct_id