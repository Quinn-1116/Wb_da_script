-- 主包单包占比
-- 主要消耗去向（场景）
-- 常玩游戏类型
-- 玩了几局太空杀？（好友同玩局占比多少）
-- 在太空杀内贡献了多少收入？
SELECT t2.appId,
       count(t2.distinct_id)
FROM
  (SELECT distinct_id
   FROM user_group_user_group_tks_label_3
   GROUP BY 1)t1
JOIN
  (SELECT t0.distinct_id,
          t0.appId
   FROM
     (SELECT distinct_id,
             time,
             appId,
             row_number()over(partition BY distinct_id
                              ORDER BY time DESC)AS time_rank
      FROM events
      WHERE event = 'login'
        AND date BETWEEN '2020-12-26' AND '2021-01-25')t0
   WHERE t0.time_rank = 1) t2 ON t1.distinct_id = t2.distinct_id
GROUP BY 1
ORDER BY 2 DESC


SELECT t2.reason_diamond,
       sum(t2.dia_amount)AS dia_amount
FROM
  (SELECT distinct_id
   FROM user_group_user_group_tks_label_3
   GROUP BY 1)t1
JOIN
  (SELECT distinct_id,reason_diamond, -sum(amount) AS dia_amount
   FROM EVENTS
   WHERE event = 'addDiamond'
     AND amount <0
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
GROUP BY 1
ORDER BY 2 DESC


SELECT t2.gameTypeId,
       sum(t2.dia_amount)AS dia_amount
FROM
  (SELECT distinct_id
   FROM user_group_user_group_tks_label_3
   GROUP BY 1)t1
JOIN
  (SELECT distinct_id,gameTypeId, -sum(amount) AS dia_amount
   FROM EVENTS
   WHERE event = 'addDiamond'
     AND amount <0
     AND date BETWEEN '2020-12-26' AND '2021-01-25'
     and gameTypeId is not null
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
GROUP BY 1
ORDER BY 2 DESC
limit 10

--常玩游戏类型
SELECT t2.gameTypeId,
       avg(t2.game_num)
FROM
  (SELECT distinct_id
   FROM user_group_user_group_tks_label_3
   GROUP BY 1)t1
JOIN
  (SELECT distinct_id,
          gameTypeId,
          count(distinct_id)AS game_num
   FROM events
   WHERE event = 'gameOver'
     AND date BETWEEN'2020-12-26' AND '2021-01-25'
   GROUP BY 1,
            2)t2 on t1.distinct_id = t2.distinct_id
GROUP BY 1
ORDER BY 2 DESC
limit 10