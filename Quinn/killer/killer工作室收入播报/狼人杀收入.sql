--购买道具

SELECT t1.date,
       t1.prop_cost,
       t3.gift_cost,
       t4.activity_cost,
       t1.prop_cost+t3.gift_cost+t4.activity_cost AS wolf
FROM
  (SELECT t0.date,
          sum(t0.prop_cost)AS prop_cost
   FROM
     (SELECT date,sum(-amount)/10 AS prop_cost--使用钻石购买各种卡片（加时卡、身份卡）、麦克风、皮肤

      FROM events
      WHERE event = 'addDiamond'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND amount <0
        AND reason_diamond LIKE '%wolf%'
        AND reason_diamond NOT LIKE '%activity_wolf%'
      GROUP BY 1
      UNION ALL SELECT date,sum(-amount)/10 AS prop_cost--使用钻石购买各种卡片（加时卡、身份卡）、麦克风、皮肤

      FROM events
      WHERE event = 'addDiamond'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND amount <0
        AND reason_diamond ='buy_time_card_self'
      GROUP BY 1
      UNION ALL SELECT date,sum(-amount)/10 AS prop_cost--使用钻石购买各种卡片（加时卡、身份卡）、麦克风、皮肤

      FROM events
      WHERE event = 'addDiamond'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND amount <0
        AND reason_diamond ='buy_time_card_other'
      GROUP BY 1
      UNION ALL SELECT date,sum(-amount)/10 AS prop_cost--使用钻石购买各种卡片（加时卡、身份卡）、麦克风、皮肤

      FROM events
      WHERE event = 'addDiamond'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND amount <0
        AND reason_diamond ='buy_time_card'
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_cost)AS prop_cost--狼人杀豆豆消耗折算成收入

      FROM
        (SELECT date,-sum(amount)/1554 AS doudou_cost
         FROM events
         WHERE event = 'addItem'
           AND item_id = 1
           AND amount <0
           AND reason = 'wolf_reduce_luckyBag'
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
         GROUP BY 1
         UNION ALL SELECT date,-sum(amount)/1554 AS doudou_cost
         FROM events
         WHERE event = 'addItem'
           AND item_id = 1
           AND amount <0
           AND reason = 'wolf_double_expcard_7round'
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
         GROUP BY 1
         UNION ALL SELECT date,sum(amount)/1554 AS doudou_cost
         FROM events
         WHERE event = 'exchange'
           AND currency_type = 'doudou'
           AND goods_name = '银水福袋'
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
         GROUP BY 1)t0
      GROUP BY 1)t0
   GROUP BY 1)t1
LEFT JOIN
  (SELECT t0.date,sum(t0.gift_cost)AS gift_cost--狼人杀送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =1004
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =1004
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =1004
        AND money_sum >0
      GROUP BY 1)t0
   GROUP BY 1)t3 ON t1.date = t3.date
LEFT JOIN
  (SELECT date,sum(activity_cost)AS activity_cost
   FROM
     (SELECT date,sum(-amount)/10 AS activity_cost
      FROM events
      WHERE event = 'addDiamond'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND amount <0
        AND reason_diamond LIKE '%activity_wolf%'
      GROUP BY 1
      UNION ALL SELECT date,sum(-amount)/ 1554 AS activity_cost
      FROM events
      WHERE event = 'addItem'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND item_id = 1
        AND amount <0
        AND reason LIKE '%activity_wolf%'
      GROUP BY 1)t0
   GROUP BY 1)t4 ON t1.date = t4.date
ORDER BY 1 /*MAX_QUERY_EXECUTION_TIME=3000*/