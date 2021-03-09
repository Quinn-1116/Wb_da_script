"""
Connect senior:Mainland
"""
import pandas as pd
import numpy as np
import json
import requests

def ssql(sql):
    admin_token = 'ae810dc4282e3de074ab08ab631f3461218accf99143b8f3a272e64c1b4c6d0e'
    url = 'http://sensor.wb-intra.com/api/sql/query?token=%s&project=production' % admin_token
    data = {'q': sql, 'format': 'json'}
    req = requests.post(url,data)
    req_dec = req.content.decode()
    try:
        req_json = json.loads('[' + req_dec
                              .replace('\n', ',')[:-1] + ']')
        df_d_id = pd.DataFrame(req_json)
        return df_d_id
    except:
        print(req_dec)

import datetime
today = (datetime.datetime.today()-datetime.timedelta(days=1)).strftime('%Y-%m-%d')
yesterday = (datetime.datetime.today()-datetime.timedelta(days=2)).strftime('%Y-%m-%d')
last_week = (datetime.datetime.today()-datetime.timedelta(days=8)).strftime('%Y-%m-%d')

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
                   '30015',
                   '20009')
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
   GROUP BY 1)t1
LEFT JOIN
  (SELECT t2.date, sum(t2.killer_store_diamond)/10 AS wanba_store_cost--主包商城兑换

   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'login'
        AND appId IN ('10001',
                      '10002')
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
                      '10002')
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
                      '10002')
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

# 构造SQL列表
sql_list = [sql_killer,sql_wolf,sql_dash,sql_draw,sql_guess,sql_uno,sql_avalong,sql_animal,sql_mine,sql_ball,sql_billiard,sql_play,sql_spy,sql_wuzi,sql_other]
game_list = ['killer','wolf','dash','draw','guess','uno','avalong','animal','mine','ball','billiard','play','spy','wuzi','other']

# 构造游戏收入字典
df_dict = {}
for game,sql in zip(game_list,sql_list):
    temp = {game:ssql(sql = sql)}
    df_dict.update(temp)

df_dict_2 = {}
for key in df_dict.keys():
    df_temp = df_dict[key].T
    df_temp.columns = df_temp.iloc[0]
    df_temp.drop(index='date',inplace=True)
    df_temp.sort_index(axis=1,ascending=False,inplace=True)
#     df_dict_2.update('{}'.format(key):'{}'.format(df_temp))
    temp = {key:df_temp}
    df_dict_2.update(temp)

for game in game_list:
    if game == 'killer':
        df_killer = df_dict_2[game]
        killer_today_total = df_killer.loc['killer', today]
        killer_yesterday_total = df_killer.loc['killer', yesterday]
        killer_lastweek_total = df_killer.loc['killer', last_week]

        killer_today_pay = df_killer.loc['单包总付费', today]
        killer_yesterday_pay = df_killer.loc['单包总付费', yesterday]
        killer_lastweek_pay = df_killer.loc['单包总付费', last_week]

        killer_today_activity = df_killer.loc['活动收入', today]
        killer_yesterday_activity = df_killer.loc['活动收入', yesterday]
        killer_lastweek_activity = df_killer.loc['活动收入', last_week]

        killer_today_prop = df_killer.loc['道具收入', today]
        killer_yesterday_prop = df_killer.loc['道具收入', yesterday]
        killer_lastweek_prop = df_killer.loc['道具收入', last_week]

        killer_today_gift = df_killer.loc['主包送礼收入', today]
        killer_yesterday_gift = df_killer.loc['主包送礼收入', yesterday]
        killer_lastweek_gift = df_killer.loc['主包送礼收入', last_week]

    elif game == 'wolf':
        df_wolf = df_dict_2[game]
        wolf_today_total = df_wolf.loc['wolf', today]
        wolf_yesterday_total = df_wolf.loc['wolf', yesterday]
        wolf_lastweek_total = df_wolf.loc['wolf', last_week]

        wolf_today_prop = df_wolf.loc['道具收入', today]
        wolf_yesterday_prop = df_wolf.loc['道具收入', yesterday]
        wolf_lastweek_prop = df_wolf.loc['道具收入', last_week]

        wolf_today_gift = df_wolf.loc['送礼收入', today]
        wolf_yesterday_gift = df_wolf.loc['送礼收入', yesterday]
        wolf_lastweek_gift = df_wolf.loc['送礼收入', last_week]

    #         wolf_today_activity = df_wolf.loc['活动收入',today]
    #         wolf_yesterday_activity = df_wolf.loc['活动收入',yesterday]
    #         wolf_lastweek_activity = df_wolf.loc['活动收入',last_week]
    elif game == 'dash':
        df_dash = df_dict_2[game]

        dash_today_total = df_dash.loc['dash', today]
        dash_yesterday_total = df_dash.loc['dash', yesterday]
        dash_lastweek_total = df_dash.loc['dash', last_week]

        dash_today_prop = df_dash.loc['道具收入', today]
        dash_yesterday_prop = df_dash.loc['道具收入', yesterday]
        dash_lastweek_prop = df_dash.loc['道具收入', last_week]

        dash_today_gift = df_dash.loc['送礼收入', today]
        dash_yesterday_gift = df_dash.loc['送礼收入', yesterday]
        dash_lastweek_gift = df_dash.loc['送礼收入', last_week]

        dash_today_niudan = df_dash.loc['扭蛋机收入', today]
        dash_yesterday_niudan = df_dash.loc['扭蛋机收入', yesterday]
        dash_lastweek_niudan = df_dash.loc['扭蛋机收入', last_week]

    elif game == 'uno':
        df_uno = df_dict_2[game]

        uno_today_total = df_uno.loc['uno', today]
        uno_yesterday_total = df_uno.loc['uno', yesterday]
        uno_lastweek_total = df_uno.loc['uno', last_week]

        uno_today_prop = df_uno.loc['道具收入', today]
        uno_yesterday_prop = df_uno.loc['道具收入', yesterday]
        uno_lastweek_prop = df_uno.loc['道具收入', last_week]

        uno_today_gift = df_uno.loc['送礼收入', today]
        uno_yesterday_gift = df_uno.loc['送礼收入', yesterday]
        uno_lastweek_gift = df_uno.loc['送礼收入', last_week]

        uno_today_choucheng = df_uno.loc['抽成', today]
        uno_yesterday_choucheng = df_uno.loc['抽成', yesterday]
        uno_lastweek_choucheng = df_uno.loc['抽成', last_week]

        uno_today_caicaile = df_uno.loc['猜猜乐收入', today]
        uno_yesterday_caicaile = df_uno.loc['猜猜乐收入', yesterday]
        uno_lastweek_caicaile = df_uno.loc['猜猜乐收入', last_week]

        uno_today_zhuofei = df_uno.loc['桌费', today]
        uno_yesterday_zhuofei = df_uno.loc['桌费', yesterday]
        uno_lastweek_zhuofei = df_uno.loc['桌费', last_week]

    elif game == 'draw':
        df_draw = df_dict_2[game]
        draw_today_total = df_draw.loc['draw', today]
        draw_yesterday_total = df_draw.loc['draw', yesterday]
        draw_lastweek_total = df_draw.loc['draw', last_week]

        draw_today_prop = df_draw.loc['道具收入', today]
        draw_yesterday_prop = df_draw.loc['道具收入', yesterday]
        draw_lastweek_prop = df_draw.loc['道具收入', last_week]

        draw_today_gift = df_draw.loc['送礼收入', today]
        draw_yesterday_gift = df_draw.loc['送礼收入', yesterday]
        draw_lastweek_gift = df_draw.loc['送礼收入', last_week]

    #     elif game == 'guess':
    #         df_guess = df_dict_2[game]
    #         if df_guess.columns[0] != today:
    #             print("今日暂无收入")
    #         else:
    #             guess_today_total = df_guess.loc['guess',today]
    #             guess_yesterday_total = df_guess.loc['guess',yesterday]
    #             guess_lastweek_total = df_guess.loc['guess',last_week]

    #             guess_today_prop = df_guess.loc['道具收入',today]
    #             guess_yesterday_prop = df_guess.loc['道具收入',yesterday]
    #             guess_lastweek_prop = df_guess.loc['道具收入',last_week]

    #             guess_today_gift = df_guess.loc['送礼收入',today]
    #             guess_yesterday_gift = df_guess.loc['送礼收入',yesterday]
    #             guess_lastweek_gift = df_guess.loc['送礼收入',last_week]

    elif game == 'avalong':
        df_avalong = df_dict_2[game]

        avalong_today_total = df_avalong.loc['avalong', today]
        avalong_yesterday_total = df_avalong.loc['avalong', yesterday]
        avalong_lastweek_total = df_avalong.loc['avalong', last_week]

    elif game == 'mine':
        df_mine = df_dict_2[game]

        mine_today_total = df_mine.loc['mine', today]
        mine_yesterday_total = df_mine.loc['mine', yesterday]
        mine_lastweek_total = df_mine.loc['mine', last_week]

        mine_today_prop = df_mine.loc['道具收入', today]
        mine_yesterday_prop = df_mine.loc['道具收入', yesterday]
        mine_lastweek_prop = df_mine.loc['道具收入', last_week]

        mine_today_gift = df_mine.loc['送礼收入', today]
        mine_yesterday_gift = df_mine.loc['送礼收入', yesterday]
        mine_lastweek_gift = df_mine.loc['送礼收入', last_week]

    elif game == 'ball':
        df_ball = df_dict_2[game]

        ball_today_total = df_ball.loc['ball', today]
        ball_yesterday_total = df_ball.loc['ball', yesterday]
        ball_lastweek_total = df_ball.loc['ball', last_week]

    elif game == 'billiard':
        df_billiard = df_dict_2[game]

        billiard_today_total = df_billiard.loc['billiard', today]
        billiard_yesterday_total = df_billiard.loc['billiard', yesterday]
        billiard_lastweek_total = df_billiard.loc['billiard', last_week]

        billiard_today_prop = df_billiard.loc['道具收入', today]
        billiard_yesterday_prop = df_billiard.loc['道具收入', yesterday]
        billiard_lastweek_prop = df_billiard.loc['道具收入', last_week]

        billiard_today_gift = df_billiard.loc['送礼收入', today]
        billiard_yesterday_gift = df_billiard.loc['送礼收入', yesterday]
        billiard_lastweek_gift = df_billiard.loc['送礼收入', last_week]

    elif game == 'play':
        df_play = df_dict_2[game]

        play_today_total = df_play.loc['play', today]
        play_yesterday_total = df_play.loc['play', yesterday]
        play_lastweek_total = df_play.loc['play', last_week]
    elif game == 'spy':
        df_spy = df_dict_2[game]

        spy_today_total = df_spy.loc['spy', today]
        spy_yesterday_total = df_spy.loc['spy', yesterday]
        spy_lastweek_total = df_spy.loc['spy', last_week]

        spy_today_prop = df_spy.loc['道具收入', today]
        spy_yesterday_prop = df_spy.loc['道具收入', yesterday]
        spy_lastweek_prop = df_spy.loc['道具收入', last_week]

        spy_today_gift = df_spy.loc['送礼收入', today]
        spy_yesterday_gift = df_spy.loc['送礼收入', yesterday]
        spy_lastweek_gift = df_spy.loc['送礼收入', last_week]

    #     elif game == 'animal':
    #         df_animal = df_dict_2[game]
    #         if df_animal.columns[0] != today:
    #             print("今日暂无收入")
    #         else:
    #             animal_today_total = df_animal.loc['animal',today]
    #             animal_yesterday_total = df_animal.loc['animal',yesterday]
    #             animal_lastweek_total = df_animal.loc['animal',last_week]

    #             animal_today_prop = df_animal.loc['道具收入',today]
    #             animal_yesterday_prop = df_animal.loc['道具收入',yesterday]
    #             animal_lastweek_prop = df_animal.loc['道具收入',last_week]

    #             animal_today_gift = df_animal.loc['送礼收入',today]
    #             animal_yesterday_gift = df_animal.loc['送礼收入',yesterday]
    #             animal_lastweek_gift = df_animal.loc['送礼收入',last_week]

    elif game == 'wuzi':
        df_wuzi = df_dict_2[game]

        wuzi_today_total = df_wuzi.loc['wuzi', today]
        wuzi_yesterday_total = df_wuzi.loc['wuzi', yesterday]
        wuzi_lastweek_total = df_wuzi.loc['wuzi', last_week]

        wuzi_today_prop = df_wuzi.loc['道具收入', today]
        wuzi_yesterday_prop = df_wuzi.loc['道具收入', yesterday]
        wuzi_lastweek_prop = df_wuzi.loc['道具收入', last_week]

        wuzi_today_gift = df_wuzi.loc['送礼收入', today]
        wuzi_yesterday_gift = df_wuzi.loc['送礼收入', yesterday]
        wuzi_lastweek_gift = df_wuzi.loc['送礼收入', last_week]

    elif game == 'other':
        df_other = df_dict_2[game]

        other_today_total_1 = df_other.loc['other', today]
        other_yesterday_total_1 = df_other.loc['other', yesterday]
        other_lastweek_total_1 = df_other.loc['other', last_week]


def per_tf(x):
    return '%.1f%%' % (x * 100)

def compare(number_1, number_2):
    a = (number_1 - number_2) / number_2
    if number_1 >= number_2:
        return "↑" + per_tf(a)
    else:
        return "↓" + per_tf(np.abs(a))

# 其他游戏（扫雷、阿瓦隆、剧本杀、怼球、台球、五子棋）
other_today_total = mine_today_total + avalong_today_total + play_today_total + ball_today_total + billiard_today_total + wuzi_today_total + other_today_total_1 + uno_today_total + draw_today_total
other_yesterday_total = mine_yesterday_total + avalong_yesterday_total + play_yesterday_total + ball_yesterday_total + billiard_yesterday_total + wuzi_yesterday_total + other_yesterday_total_1 + uno_yesterday_total + draw_yesterday_total
other_lastweek_total = mine_lastweek_total + avalong_lastweek_total + play_lastweek_total + ball_lastweek_total + billiard_lastweek_total + wuzi_lastweek_total + other_lastweek_total_1 + uno_lastweek_total + draw_lastweek_total

# 游戏总收入
today_total_income = killer_today_total + wolf_today_total + dash_today_total  + other_today_total
yesterday_total_income = killer_yesterday_total + wolf_yesterday_total + dash_yesterday_total + other_yesterday_total
lastweek_total_income = killer_lastweek_total + wolf_lastweek_total + dash_lastweek_total + other_lastweek_total

# 构造收入项列表
income_key = ['太空杀单包充值','主包太空杀活动','主包太空杀道具消耗','主包太空杀送礼','狼人杀道具','狼人杀送礼','撞王道具','撞王送礼','撞王扭蛋','乌诺道具','乌诺送礼','乌诺抽成','乌诺猜猜乐','乌诺桌费','画猜道具','画猜送礼']
game_income = [killer_today_pay,killer_today_activity,killer_today_prop,killer_today_gift,wolf_today_prop,wolf_today_gift,dash_today_prop,dash_today_gift,dash_today_niudan,uno_today_prop,uno_today_gift,uno_today_choucheng,uno_today_caicaile,uno_today_zhuofei,draw_today_prop,draw_today_gift]

# 构造收入字典
income_dict = {}
for key,income in zip(income_key,game_income):
    temp_income = {key:round(income,2)}
    income_dict.update(temp_income)

income_list = sorted(income_dict.items(),key = lambda item:item[1])

mark_down_data = '''
**{date_1} KILLER工作室收入播报**  
**当日总收入：<font color="#FF0000">{today_total_income}元</font>**  
环比昨日{total_rate_yesterday},同比上周{total_rate_lastweek}  
**当日收入贡献TOP5分别为：** 
1. {item_1}: {income_1}, 占比{p_1}  
2. {item_2}: {income_2}, 占比{p_2}  
3. {item_3}: {income_3}, 占比{p_3}  
4. {item_4}: {income_4}, 占比{p_4}  
5. {item_5}: {income_5}, 占比{p_5}  

**各项游戏收入涨跌详情**  
**<font color="#FF0000">太空杀</font>**  
当日收入：{killer_today_total}, 环比{killer_rate_yesterday}, 同比{killer_rate_lastweek}  
**<font color="#FF0000">狼人杀</font>**  
当日收入：{wolf_today_total},环比{wolf_rate_yesterday},同比{wolf_rate_lastweek}  
**<font color="#FF0000">撞王</font>**  
当日收入：{dash_today_total},环比{dash_rate_yesterday},同比{dash_rate_lastweek}  
**<font color="#FF0000">其他游戏</font>**  
当日收入：{other_today_total},环比{other_rate_yesterday},同比{other_rate_lastweek}  
'''
markdown_file = mark_down_data.format(
    date_1=today,
    # 收入贡献TOP5
    item_1=list(income_list[-1])[0], income_1=list(income_list[-1])[1],
    p_1=per_tf(list(income_list[-1])[1] / today_total_income),
    item_2=list(income_list[-2])[0], income_2=list(income_list[-2])[1],
    p_2=per_tf(list(income_list[-2])[1] / today_total_income),
    item_3=list(income_list[-3])[0], income_3=list(income_list[-3])[1],
    p_3=per_tf(list(income_list[-3])[1] / today_total_income),
    item_4=list(income_list[-4])[0], income_4=list(income_list[-4])[1],
    p_4=per_tf(list(income_list[-4])[1] / today_total_income),
    item_5=list(income_list[-5])[0], income_5=list(income_list[-5])[1],
    p_5=per_tf(list(income_list[-5])[1] / today_total_income),

    # KILLER工作室总收入
    today_total_income=round(today_total_income, 2),
    total_rate_yesterday=compare(today_total_income, yesterday_total_income),
    total_rate_lastweek=compare(today_total_income, lastweek_total_income),

    # 太空杀收入涨跌
    killer_today_total=round(killer_today_total, 2),
    killer_rate_yesterday=compare(killer_today_total, killer_yesterday_total),
    killer_rate_lastweek=compare(killer_today_total, killer_lastweek_total),

    # 狼人杀收入涨跌
    wolf_today_total=round(wolf_today_total, 2),
    wolf_rate_yesterday=compare(wolf_today_total, wolf_yesterday_total),
    wolf_rate_lastweek=compare(wolf_today_total, wolf_lastweek_total),

    # 撞王收入涨跌
    dash_today_total=round(dash_today_total, 2),
    dash_rate_yesterday=compare(dash_today_total, dash_yesterday_total),
    dash_rate_lastweek=compare(dash_today_total, dash_lastweek_total),

    # 画猜
    # draw_today_total=round(draw_today_total, 2),
    # draw_rate_yesterday=compare(draw_today_total, draw_yesterday_total),
    # draw_rate_lastweek=compare(draw_today_total, draw_lastweek_total),
    #
    # # 乌诺
    # uno_today_total=round(uno_today_total, 2),
    # uno_rate_yesterday=compare(uno_today_total, uno_yesterday_total),
    # uno_rate_lastweek=compare(uno_today_total, uno_lastweek_total),

    # 其他游戏（扫雷、阿瓦隆、剧本杀、怼球、台球、五子棋、画猜、乌诺）
    other_today_total=round(other_today_total, 2),
    other_rate_yesterday=compare(other_today_total, other_yesterday_total),
    other_rate_lastweek=compare(other_today_total, other_lastweek_total)
)


from dingtalkchatbot.chatbot import DingtalkChatbot
# 播报群
# webhook = "https://oapi.dingtalk.com/robot/send?access_token=732ceae762f83b1f37500af5df4016de5741e5251c0a49f62c5c824173fb4121"
# secret = "SECfa31e7be280d10eb497754f02087759cc9f71dc3c391f27b47bf8967139bea6b"

# 测试群
webhook = "https://oapi.dingtalk.com/robot/send?access_token=2606c23eaf70851235a10785081a8fedcc72d210c9379c9b960c32d571372b8a"
secret = "SEC2fe3fce80cc0a5b2de41423c540b8f58c2f2c393a7c2ec28c75d9bdd0062939e"
xiaoding = DingtalkChatbot(webhook, secret=secret)
xiaoding.send_markdown(title='killer工作室收入播报', text=markdown_file, is_at_all=True)
print("播报已发送")

