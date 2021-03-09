--太空杀收入
 --太空杀单包充值金额

SELECT t1.date,
       t1.total_pay,
       t2.wanba_store_cost,
       t3.wanba_activity_cost,
       t4.game_gift_cost,
       t1.total_pay+t2.wanba_store_cost+t3.wanba_activity_cost+t4.game_gift_cost AS killer
FROM
  (SELECT date,sum(pay)AS total_pay--单包充值

   FROM events
   WHERE event = 'pay'
     AND appId IN ('20014',
                   '30015')
     AND date BETWEEN current_date() - interval 7 DAY AND current_date() - interval 1 DAY
   GROUP BY 1)t1
LEFT JOIN
  (SELECT t2.date, sum(t2.killer_store_diamond)/10 AS wanba_store_cost--主包商城兑换

   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('10001',
                      '10002',
                      '20009')
        AND date BETWEEN current_date() - interval 7 DAY AND current_date() - interval 1 DAY
      GROUP BY 1,
               2) t1
   JOIN
     (SELECT date,distinct_id,
                  sum(amount) AS killer_store_diamond
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
                       1183,
                       1188,
                       1189,
                       1190)
        AND date BETWEEN current_date() - interval 7 DAY AND current_date() - interval 1 DAY
      GROUP BY 1,
               2)t2 ON t1.date = t2.date
   AND t1.distinct_id = t2.distinct_id
   GROUP BY 1)t2 ON t1.date = t2.date
LEFT JOIN
  (SELECT t2.date,sum(t2.activity_killer_diamond)/ 10 AS wanba_activity_cost--主包活动消耗

   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('10001',
                      '10002',
                      '20009')
        AND date BETWEEN current_date() - interval 7 DAY AND current_date() - interval 1 DAY
      GROUP BY 1,
               2) t1
   JOIN
     (SELECT date,distinct_id, -sum(amount) AS activity_killer_diamond
      FROM events
      WHERE event = 'addDiamond'
        AND amount <0
        AND reason_diamond LIKE '%activity_killer%'
        AND date BETWEEN current_date() - interval 7 DAY AND current_date() - interval 1 DAY
      GROUP BY 1,
               2)t2 ON t1.date = t2.date
   AND t1.distinct_id = t2.distinct_id
   GROUP BY 1)t3 ON t1.date = t3.date
LEFT JOIN
  (SELECT date,sum(diamond_sum)/10 AS game_gift_cost--游戏内送礼

   FROM events
   WHERE event = 'sendGift'
     AND gameTypeId = 1800
     AND diamond_sum >0
     AND date BETWEEN current_date() - interval 7 DAY AND current_date() - interval 1 DAY
   GROUP BY 1)t4 ON t1.date = t4.date

ORDER BY 1