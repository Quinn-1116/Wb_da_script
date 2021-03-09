--游戏活跃
 --游戏等级、游戏局数（分模式、年龄、汇总看）、游戏时长、
--静态属性
 --注册时间、城市、注册性别、注册渠道、操作系统
--付费属性
 --付费金额、付费次数
--社交属性
 --加好友数量
 --被加次数

SELECT t1.distinct_id,
       t2.reg_time,
       t2.reg_gender,
       t2.reg_appId,
       t3.pay AS `总付费金额`,
       t11.diamond_amount/10 AS `总消耗金额`,
       t3.pay_time AS `总付费次数`,
       t4.add_num AS `加好友次数`,
       t5.added_num AS `被加次数`,
       t6.$city AS `城市`,
       t12.game_num AS `游戏总局数`,
       t7.`新手场局数`,
       t7.`躲猫猫局数`,
       t7.`进阶场局数`,
       t7.`技能场局数`,
       t8.`默认场局数`,
       t8.`青少年局数`,
       t8.`成年场局数`,
       t9.last_login_date AS `最后一次登录时间`,
       t10.last_game_date AS `最后一次游戏时间`
FROM
  (SELECT distinct_id
   FROM events
   WHERE event = 'exchange'
     AND currency_type = 'diamond'
     AND tag_id in(1153,1154,1155,1156,1158,1160,1161,1165)
     AND date BETWEEN '2020-11-28' AND current_date()
   GROUP BY 1
   UNION SELECT distinct_id
   FROM events
   WHERE event = 'addDiamond'
     AND reason_diamond = 'buy_killer_prop'
     AND date BETWEEN '2020-10-31' AND '2020-11-27'
   GROUP BY 1)t1
LEFT JOIN
  (SELECT second_id,
          FROM_UNIXTIME(CAST($signup_time/1000 AS BIGINT),'yyyy/MM/dd')AS reg_time,
          reg_gender,
          reg_appId
   FROM users
   WHERE second_id IS NOT NULL) t2 ON t1.distinct_id = t2.second_id
LEFT JOIN
  (SELECT distinct_id,
          sum(pay) AS pay,
          count(distinct_id)AS pay_time
   FROM events
   WHERE event = 'pay'
     AND date BETWEEN '2020-10-31' AND current_date()
   GROUP BY 1)t3 ON t1.distinct_id = t3.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          count(distinct_id)AS add_num
   FROM events
   WHERE event = 'addFriendNew'
     AND gameTypeId = 1800
     AND RESULT = '0'
     AND date BETWEEN '2020-10-20' AND current_date()
   GROUP BY 1)t4 ON t1.distinct_id = t4.distinct_id
LEFT JOIN
  (SELECT friendID,
          count(distinct_id)AS added_num
   FROM events
   WHERE event = 'addFriendNew'
     AND gameTypeId = 1800
     AND RESULT = '0'
     AND date BETWEEN '2020-10-20' AND current_date()
   GROUP BY 1)t5 ON t1.distinct_id = t5.friendID
LEFT JOIN
  (SELECT distinct_id,
          $city
   FROM events
   WHERE event = 'register'
     AND date BETWEEN '2020-10-16' AND current_date()
   GROUP BY 1,
            2)t6 ON t1.distinct_id = t6.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          count(CASE WHEN gameSubtype = '1' THEN 1 ELSE NULL END)AS `新手场局数`,
          count(CASE WHEN gameSubtype = '2' THEN 1 ELSE NULL END)AS `躲猫猫局数`,
          count(CASE WHEN gameSubtype = '3' THEN 1 ELSE NULL END)AS `进阶场局数`,
          count(CASE WHEN gameSubtype = '4' THEN 1 ELSE NULL END)AS `技能场局数`
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-10-16' AND current_date()
   GROUP BY 1)t7 ON t1.distinct_id = t7.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          count(CASE WHEN ageType = '0' THEN 1 ELSE NULL END)AS `默认场局数`,
          count(CASE WHEN ageType = '1' THEN 1 ELSE NULL END)AS `青少年局数`,
          count(CASE WHEN ageType = '2' THEN 1 ELSE NULL END)AS `成年场局数`
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-20' AND current_date()
   GROUP BY 1)t8 ON t1.distinct_id = t8.distinct_id
LEFT JOIN
  (SELECT t1.distinct_id,
          t1.date AS last_login_date
   FROM
     (SELECT date,distinct_id,
                  row_number()over(partition BY distinct_id
                                   ORDER BY time DESC)AS time_rank
      FROM events
      WHERE event = 'login'
        AND date BETWEEN '2020-10-31' AND current_date())t1
   WHERE t1.time_rank = 1)t9 ON t1.distinct_id = t9.distinct_id
LEFT JOIN
  (SELECT t1.distinct_id,
          t1.date AS last_game_date
   FROM
     (SELECT date,distinct_id,
                  row_number()over(partition BY distinct_id
                                   ORDER BY time DESC)AS time_rank
      FROM events
      WHERE event = 'gameStart'
        AND date BETWEEN '2020-10-31' AND current_date()
        AND gameTypeId = 1800)t1
   WHERE t1.time_rank = 1)t10 ON t1.distinct_id = t10.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          sum(amount)AS diamond_amount
   FROM events
   WHERE event = 'addDiamond'
     AND amount < 0
     AND date BETWEEN '2020-10-31' AND current_date()
   GROUP BY 1)t11 ON t1.distinct_id = t11.distinct_id
LEFT JOIN
  (SELECT distinct_id,
          count(distinct_id)AS game_num
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-10-31' AND current_date()
   GROUP BY 1)t12 ON t1.distinct_id = t12.distinct_id