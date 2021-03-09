
SELECT t0.distinct_id,
       t1.game_num,
       t1.game_duration,
       t2.pay_num,
       t2.pay_sum,
       t3.friend_num
FROM
  (SELECT distinct_id
   FROM events
   WHERE event = 'login'
     AND appId IN ('20014',
                   '30015')
     AND date BETWEEN '2020-12-25' AND '2021-01-24'
   GROUP BY 1)t0
LEFT JOIN
  (SELECT distinct_id,
          count(distinct_id)AS game_num,
          sum(duration)/60000 AS game_duration
   FROM events
   WHERE event = 'gameOver'
     AND date BETWEEN '2020-12-25' AND '2021-01-24'
     AND gameTypeId = 1800
   GROUP BY 1)t1 ON t0.distinct_id = t1.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          count(distinct_id)AS pay_num,
          sum(pay)AS pay_sum
   FROM events
   WHERE event = 'pay'
     AND date BETWEEN '2020-12-25' AND '2021-01-24'
   GROUP BY 1)t2 ON t0.distinct_id = t2.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          count(distinct_id)AS friend_num
   FROM EVENTS
   WHERE event = 'addFriendNew'
     AND date BETWEEN '2020-12-25' AND '2021-01-24'
   GROUP BY 1)t3 ON t0.distinct_id = t3.distinct_id