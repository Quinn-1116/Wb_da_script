sql_killer = """
SELECT t1.date,
       t1.total_pay as `单包总付费`,
       t2.wanba_store_cost as `道具收入`,
       t3.wanba_activity_cost as `活动收入`,
       t4.game_gift_cost as `主包送礼收入`,
       t1.total_pay+t2.wanba_store_cost+t3.wanba_activity_cost+t4.game_gift_cost AS killer
FROM
  (SELECT date,sum(pay)AS total_pay--单包充值

   FROM events
   WHERE event = 'pay'
     AND appId IN ('20014',
                   '30015')
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
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
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
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
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
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
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1,
               2) t1
   JOIN
     (SELECT date,distinct_id, -sum(amount) AS activity_killer_diamond
      FROM events
      WHERE event = 'addDiamond'
        AND amount <0
        AND reason_diamond LIKE '%activity_killer%'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1,
               2)t2 ON t1.date = t2.date
   AND t1.distinct_id = t2.distinct_id
   GROUP BY 1)t3 ON t1.date = t3.date
LEFT JOIN
  (SELECT t1.date, sum(t2.diamond_sum)AS game_gift_cost
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('10001',
                      '10002',
                      '20009')
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1,
               2) t1
   LEFT JOIN
     (SELECT date,distinct_id,
                  sum(diamond_sum)/10 AS diamond_sum
      FROM events
      WHERE event = 'sendGift'
        AND gameTypeId = 1800
        AND diamond_sum >0
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1,
               2)t2 ON t1.date = t2.date
   AND t1.distinct_id =t2.distinct_id
   GROUP BY 1)t4 ON t1.date = t4.date
ORDER BY 1
"""
sql_wolf = """
SELECT t1.date,
       t1.prop_cost as `道具收入`,
       t3.gift_cost as `送礼收入`,
       t4.activity_cost as `活动收入`,
       t1.prop_cost+t3.gift_cost AS wolf
FROM
  (SELECT t0.date,
          sum(t0.prop_cost)AS prop_cost
   FROM
     (SELECT date,sum(-amount)/10 AS prop_cost--使用钻石购买各种卡片（加时卡、身份卡）、麦克风、皮肤

      FROM events
      WHERE event = 'addDiamond'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND amount <0
        AND reason_diamond LIKE '%wolf%'
        AND reason_diamond NOT LIKE '%activity_wolf%'
      GROUP BY 1
      UNION ALL SELECT date,sum(-amount)/10 AS prop_cost--使用钻石购买各种卡片（加时卡、身份卡）、麦克风、皮肤

      FROM events
      WHERE event = 'addDiamond'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND amount <0
        AND reason_diamond ='buy_time_card_self'
      GROUP BY 1
      UNION ALL SELECT date,sum(-amount)/10 AS prop_cost--使用钻石购买各种卡片（加时卡、身份卡）、麦克风、皮肤

      FROM events
      WHERE event = 'addDiamond'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND amount <0
        AND reason_diamond ='buy_time_card_other'
      GROUP BY 1
      UNION ALL SELECT date,sum(-amount)/10 AS prop_cost--使用钻石购买各种卡片（加时卡、身份卡）、麦克风、皮肤

      FROM events
      WHERE event = 'addDiamond'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
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
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1
         UNION ALL SELECT date,-sum(amount)/1554 AS doudou_cost
         FROM events
         WHERE event = 'addItem'
           AND item_id = 1
           AND amount <0
           AND reason = 'wolf_double_expcard_7round'
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1
         UNION ALL SELECT date,sum(amount)/1554 AS doudou_cost
         FROM events
         WHERE event = 'exchange'
           AND currency_type = 'doudou'
           AND goods_name = '银水福袋'
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1)t0
      GROUP BY 1)t0
   GROUP BY 1)t1
LEFT JOIN
  (SELECT t0.date,sum(t0.gift_cost)AS gift_cost--狼人杀送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =1004
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =1004
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
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
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND amount <0
        AND reason_diamond LIKE '%activity_wolf%'
      GROUP BY 1
      UNION ALL SELECT date,sum(-amount)/ 1554 AS activity_cost
      FROM events
      WHERE event = 'addItem'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND item_id = 1
        AND amount <0
        AND reason LIKE '%activity_wolf%'
      GROUP BY 1)t0
   GROUP BY 1)t4 ON t1.date = t4.date
ORDER BY 1 /*MAX_QUERY_EXECUTION_TIME=3000*/
"""
sql_dash = """

SELECT t1.date,
       t1.prop_cost as `道具收入`,
       t2.doudou_cost as `扭蛋机收入`,
       t3.gift_cost as `送礼收入`,
       t1.prop_cost+t2.doudou_cost+t3.gift_cost AS dash
FROM
  (SELECT date,sum(-amount)/10 AS prop_cost--使用钻石购买各种道具、装扮等

   FROM events
   WHERE event = 'addDiamond'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
     AND amount <0
     AND reason_diamond in('ball_strike_unlock_role','dash_game_shop_product','dash_renew_suit','dash_buy_suit')
   GROUP BY 1)t1
LEFT JOIN
  (
SELECT t0.date,
       sum(t0.doudou_cost)AS doudou_cost
FROM
  (SELECT date,-sum(amount)/1554 AS doudou_cost
   FROM events
   WHERE event = 'addItem'
     AND item_id = 1
     AND amount <0
     AND reason LIKE '%dash_lottery%'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
   GROUP BY 1
   UNION ALL SELECT date,-sum(amount)/1554 AS doudou_cost
   FROM events
   WHERE event = 'addItem'
     AND item_id = 1
     AND amount <0
     AND reason ='dash_dragon_boat_activity'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
   GROUP BY 1)t0
GROUP BY 1)t2 ON t1.date = t2.date
LEFT JOIN
  (SELECT t0.date, sum(t0.gift_cost)AS gift_cost--撞击王者送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =1180
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =1180
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =1180
        AND money_sum >0
      GROUP BY 1)t0
   GROUP BY 1)t3 ON t1.date = t3.date
ORDER BY 1
"""
sql_draw = """

SELECT t1.date,
       t1.draw_prop_cost as `道具收入`,
       t2.gift_cost as `送礼收入`,
       t1.draw_prop_cost+t2.gift_cost AS draw
FROM
  (SELECT t0.date,
          sum(t0.draw_prop_cost)AS draw_prop_cost
   FROM
     (SELECT date,-sum(amount)/10 AS draw_prop_cost
      FROM events
      WHERE event = 'addDiamond'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND reason_diamond = 'buy_draw_item '
      GROUP BY 1
      UNION ALL SELECT date,-sum(amount)/1554 AS draw_prop_cost
      FROM events
      WHERE event = 'addItem'
        AND amount <0
        AND item_id = 1
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND reason = 'buy_draw_item'
      GROUP BY 1)t0
   GROUP BY 1)t1
LEFT JOIN
  (SELECT t0.date, sum(t0.gift_cost)AS gift_cost--画猜送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =101
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =101
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =101
        AND money_sum >0
      GROUP BY 1)t0
   GROUP BY 1)t2 ON t1.date = t2.date
ORDER BY 1
"""
sql_guess = """

SELECT t1.date,
       t1.guess_prop_cost as `道具收入`,
       t2.gift_cost as `送礼收入`,
       t1.guess_prop_cost + t2.gift_cost AS guess
FROM
  (SELECT t0.date,
          sum(t0.guess_prop_cost)AS guess_prop_cost
   FROM
     (SELECT date, sum(amount)/10 AS guess_prop_cost
      FROM events
      WHERE event = 'exchange'
        AND currency_type = 'diamond'
        AND tag_id =1046
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1
      UNION ALL SELECT date, sum(amount)/9774 AS guess_prop_cost
      FROM events
      WHERE event = 'exchange'
        AND currency_type = 'money'
        AND tag_id =1046
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1)t0
   GROUP BY 1)t1
JOIN
  (SELECT t0.date, sum(t0.gift_cost)AS gift_cost--画猜送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =100
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =100
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =100
        AND money_sum >0
      GROUP BY 1)t0
   GROUP BY 1)t2 ON t1.date = t2.date
ORDER BY 1
"""
sql_uno = """
SELECT t1.date,
       t1.uno_prop_cost as `道具收入`,
       t2.gift_cost as `送礼收入`,
       t3.uno_commission as `抽成`,
       t4.uno_charge as `桌费`,
       t5.revenue as `猜猜乐收入`,
       t1.uno_prop_cost+t2.gift_cost+t3.uno_commission+t4.uno_charge+t5.revenue AS uno
FROM
  (SELECT date,-sum(amount)/10 AS uno_prop_cost
   FROM events
   WHERE event = 'addDiamond'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
     AND reason_diamond = 'uno_buy_suit'
   GROUP BY 1)t1
LEFT JOIN
  (SELECT t0.date, sum(t0.gift_cost)AS gift_cost--乌诺送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =1190
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =1190
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =1190
        AND money_sum >0
      GROUP BY 1)t0
   GROUP BY 1)t2 ON t1.date = t2.date
LEFT JOIN
  (SELECT t0.date,sum(t0.uno_commission)AS uno_commission
   FROM
     (SELECT date,sum(cost_doudou)/1554 AS uno_commission--豆豆抽成

      FROM events
      WHERE event = 'gameOver'
        AND gameTypeId = 1190
        AND gameSubtype != '1'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1
      UNION ALL SELECT date,sum(cost_doudou)/9774 AS uno_commission--金币抽成

      FROM events
      WHERE event = 'gameOver'
        AND gameTypeId = 1190
        AND gameSubtype = '1'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1)t0
   GROUP BY 1) t3 ON t1.date = t3.date
LEFT JOIN
  (SELECT t0.date,sum(t0.charge)AS uno_charge
   FROM
     (SELECT date,sum(charge)/ 1554 AS charge--豆豆桌费

      FROM events
      WHERE event = 'gameOver'
        AND gameTypeId = 1190
        AND gameSubtype != '1'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1
      UNION ALL SELECT date,sum(charge)/ 9774 AS charge--金币桌费

      FROM events
      WHERE event = 'gameOver'
        AND gameTypeId = 1190
        AND gameSubtype = '1'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1)t0
   GROUP BY 1)t4 ON t1.date = t4.date
LEFT JOIN
  (SELECT t1.date, t1.doudou_revenue+t1.money_revenue+t3.doudou_revenue+t3.money_revenue-t2.doudou_revenue-t2.money_revenue AS revenue
   FROM
     (SELECT date, sum(CASE WHEN currency_type = 'DOUDOU' THEN amount ELSE NULL END)/1554 AS doudou_revenue,
                   sum(CASE WHEN currency_type = 'MONEY' THEN amount ELSE NULL END)/9774 AS money_revenue
      FROM events
      WHERE event = 'action'--输豆豆

        AND op_type = 'bet_guess_game'
        AND gameTypeId = 1190
        AND RESULT = 'lose'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1)t1
   JOIN
     (SELECT date, sum(CASE WHEN currency_type = 'DOUDOU' THEN amount ELSE NULL END)/1554 AS doudou_revenue,
                   sum(CASE WHEN currency_type = 'MONEY' THEN amount ELSE NULL END)/9774 AS money_revenue
      FROM events--赢豆豆

      WHERE event = 'action'
        AND op_type = 'bet_guess_game'
        AND gameTypeId = 1190
        AND RESULT = 'win'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1)t2 ON t1.date = t2.date
   JOIN
     (SELECT date, sum(CASE WHEN currency_type = 'DOUDOU' THEN charge ELSE NULL END)/1554 AS doudou_revenue,
                   sum(CASE WHEN currency_type = 'MONEY' THEN charge ELSE NULL END)/9774 AS money_revenue
      FROM events
      WHERE event = 'action'--赢豆豆抽成

        AND op_type = 'bet_guess_game'
        AND gameTypeId = 1190
        AND RESULT = 'win'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1)t3 ON t1.date = t3.date
   ORDER BY 1)t5 ON t1.date = t5.date
ORDER BY 1
"""

sql_avalong = """
SELECT t0.date,
       sum(t0.gift_cost)AS avalong--awalong送礼折算成收入

FROM
  (SELECT date,sum(diamond_sum)/10 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
     AND gametypeid = 1100
     AND diamond_sum >0
   GROUP BY 1
   UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
     AND gametypeid = 1100
     AND doudou_sum >0
   GROUP BY 1
   UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
     AND gametypeid = 1100
     AND money_sum >0
   GROUP BY 1)t0
GROUP BY 1
ORDER BY 1
"""
sql_animal = """

SELECT t1.date,
       t1.animal_prop_cost as `道具收入`,
       t2.gift_cost as `送礼收入`,
       t1.animal_prop_cost+t2.gift_cost AS animal
FROM
  (SELECT t0.date,
          sum(t0.animal_prop_cost)as animal_prop_cost
   FROM
     (SELECT date,-sum(amount)/10 AS animal_prop_cost
      FROM events
      WHERE event = 'addDiamond'
        AND amount <0
        AND reason_diamond = 'buy_animalchess'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1
      UNION ALL SELECT date,-sum(amount)/1554 AS animal_prop_cost
      FROM events
      WHERE event = 'addDiamond'
        AND amount <0
        AND reason = 'buy_animalchess'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1)t0
   GROUP BY 1)t1
JOIN
  (SELECT t0.date, sum(t0.gift_cost)AS gift_cost--五子棋送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid = 1207
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid = 1207
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid = 1207
        AND money_sum >0
      GROUP BY 1)t0
   GROUP BY 1)t2 ON t1.date = t2.date
ORDER BY 1
"""
sql_mine = """

SELECT t1.date,
       t1.mine_prop_cost as `道具收入`,
       t2.gift_cost as `送礼收入`,
       t1.mine_prop_cost+t2.gift_cost AS mine
FROM
  (SELECT t0.date,
          sum(t0.mine_prop_cost)AS mine_prop_cost
   FROM
     (SELECT date,-sum(amount)/10 AS mine_prop_cost
      FROM events
      WHERE event = 'addDiamond'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND reason_diamond in('buy_ming_flag','buy_mine_prop','buy_mine_table','buy_mine_gift_bag')
      GROUP BY 1
      UNION ALL SELECT date,-sum(amount)/1554 AS mine_prop_cost
      FROM events
      WHERE event = 'addItem'
        AND amount <0
        AND item_id = 1
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND reason in('buy_ming_flag','buy_mine_prop','buy_mine_table','buy_mine_gift_bag')
      GROUP BY 1
      UNION ALL SELECT date,-sum(amount)/9774 AS mine_prop_cost
      FROM events
      WHERE event = 'addMoney'
        AND amount <0
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND reason in('buy_ming_flag','buy_mine_prop','buy_mine_table','buy_mine_gift_bag')
      GROUP BY 1)t0
   GROUP BY 1)t1
LEFT JOIN
  (SELECT t0.date, sum(t0.gift_cost)AS gift_cost--画猜送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =1160
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =1160
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =1160
        AND money_sum >0
      GROUP BY 1)t0
   GROUP BY 1)t2 ON t1.date = t2.date
ORDER BY 1
"""

sql_ball = """

SELECT t0.date,
       sum(t0.gift_cost)AS ball--怼球送礼折算成收入

FROM
  (SELECT date,sum(diamond_sum)/10 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
     AND gametypeid = 1001
     AND diamond_sum >0
   GROUP BY 1
   UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
     AND gametypeid = 1001
     AND doudou_sum >0
   GROUP BY 1
   UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
     AND gametypeid = 1001
     AND money_sum >0
   GROUP BY 1)t0
GROUP BY 1
ORDER BY 1
"""
sql_billiard = """


SELECT t1.date,
       t1.billiards_prop_cost as `道具收入`,
       t2.gift_cost as `送礼收入`,
       t1.billiards_prop_cost+t2.gift_cost AS billiard
FROM
  (SELECT t0.date,
          sum(t0.billiards_prop_cost)AS billiards_prop_cost
   FROM
     (SELECT date,-sum(amount)/10 AS billiards_prop_cost
      FROM events
      WHERE event = 'addDiamond'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND reason_diamond in('buy_billiard_table','buy_billiard_cue','buy_billiard_gift_bag','upgrade_cue','advance_cue')
      GROUP BY 1
      UNION ALL SELECT date,-sum(amount)/1554 AS billiards_prop_cost
      FROM events
      WHERE event = 'addItem'
        AND amount <0
        AND item_id = 1
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND reason_diamond in('buy_billiard_table','buy_billiard_cue','buy_billiard_gift_bag','upgrade_cue','advance_cue')
      GROUP BY 1
      UNION ALL SELECT date,-sum(amount)/9774 AS billiards_prop_cost
      FROM events
      WHERE event = 'addMoney'
        AND amount <0
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND reason_diamond in('buy_billiard_table','buy_billiard_cue','buy_billiard_gift_bag','upgrade_cue','advance_cue')
      GROUP BY 1)t0
   GROUP BY 1)t1
LEFT JOIN
  (SELECT t0.date, sum(t0.gift_cost)AS gift_cost--台球送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid in(1225,1226)
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid in(1225,1226)
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid in(1225,1226)
        AND money_sum >0
      GROUP BY 1)t0
   GROUP BY 1)t2 ON t1.date = t2.date
ORDER BY 1
"""
sql_play = """

SELECT t0.date,
       sum(t0.gift_cost)AS play--剧本杀送礼折算成收入

FROM
  (SELECT date,sum(diamond_sum)/10 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
     AND gametypeid = 1171
     AND diamond_sum >0
   GROUP BY 1
   UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
     AND gametypeid = 1171
     AND doudou_sum >0
   GROUP BY 1
   UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
     AND gametypeid = 1171
     AND money_sum >0
   GROUP BY 1)t0
GROUP BY 1
ORDER BY 1
"""
sql_spy = """
SELECT t2.date,
       t2.prop_cost as `道具收入`,
       t3.gift_cost as `送礼收入`,
       t2.prop_cost + t3.gift_cost AS spy
FROM
  (SELECT t1.date,
          --使用钻石/金币兑换道具

          sum(t1.spy_store_diamond)AS prop_cost
   FROM
     (SELECT date, sum(amount)/10 AS spy_store_diamond
      FROM events
      WHERE event = 'exchange'
        AND currency_type = 'diamond'
        AND goods_id IN (90001,
                         90002,
                         90003,
                         90004)
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1
      UNION ALL SELECT date, sum(amount)/9774 AS spy_store_diamond
      FROM events
      WHERE event = 'exchange'
        AND currency_type = 'gold'
        AND goods_id =5901
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1)t1
   GROUP BY 1)t2
LEFT JOIN
  (SELECT t0.date, sum(t0.gift_cost)AS gift_cost--剧本杀送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =1150
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =1150
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid =1150
        AND money_sum >0
      GROUP BY 1)t0
   GROUP BY 1)t3 ON t2.date = t3.date
ORDER BY 1
"""

sql_wuzi = """

SELECT t1.date,
       t1.wuzi_prop_cost as `道具收入`,
       t2.gift_cost as `送礼收入`, 
       t1.wuzi_prop_cost+t2.gift_cost AS wuzi
FROM
  (SELECT t0.date,
          sum(t0.wuzi_prop_cost)AS wuzi_prop_cost
   FROM
     (SELECT date, sum(amount)/10 AS wuzi_prop_cost
      FROM events
      WHERE event = 'exchange'
        AND currency_type = 'diamond'
        AND goods_id IN (700,
                         701)
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1
      UNION ALL SELECT date, sum(amount)/9774 AS wuzi_prop_cost
      FROM events
      WHERE event = 'exchange'
        AND currency_type = 'gold'
        AND goods_id IN (700,
                         701)
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1)t0
   GROUP BY 1)t1
JOIN
  (SELECT t0.date, sum(t0.gift_cost)AS gift_cost--五子棋送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid = 1206
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid = 1206
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
        AND gametypeid = 1206
        AND money_sum >0
      GROUP BY 1)t0
   GROUP BY 1)t2 ON t1.date = t2.date
ORDER BY 1
"""

sql_other = """

SELECT t0.date,
       sum(t0.gift_cost)AS other--送礼折算成收入

FROM
  (SELECT date,sum(diamond_sum)/10 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
     AND gametypeid in(1215,1214,1212,1220,1208,1202,1219,1210,1213,1201,1200,1224,1203)
     AND diamond_sum >0
   GROUP BY 1
   UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
     AND gametypeid in(1215,1214,1212,1220,1208,1202,1219,1210,1213,1201,1200,1224,1203)
     AND doudou_sum >0
   GROUP BY 1
   UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
     AND gametypeid in(1215,1214,1212,1220,1208,1202,1219,1210,1213,1201,1200,1224,1203)
     AND money_sum >0
   GROUP BY 1)t0
GROUP BY 1
ORDER BY 1
"""