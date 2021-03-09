
SELECT t1.date,
       t1.prop_cost,
       t2.doudou_cost,
       t3.gift_cost,
       t1.prop_cost+t2.doudou_cost+t3.gift_cost AS dash
FROM
  (SELECT date,sum(-amount)/10 AS prop_cost--使用钻石购买各种道具、装扮等

   FROM events
   WHERE event = 'addDiamond'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
     AND amount <0
     AND reason_diamond in('ball_strike_unlock_role','dash_game_shop_product','dash_renew_suit','dash_buy_suit')
   GROUP BY 1)t1
LEFT JOIN
  (SELECT date,-sum(amount)/1554 AS doudou_cost
   FROM events
   WHERE event = 'addItem'
     AND item_id = 1
     AND amount <0
     AND reason in('dash_dragon_boat_activity','dash_lottery')
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
   GROUP BY 1)t2 ON t1.date = t2.date
LEFT JOIN
  (SELECT t0.date, sum(t0.gift_cost)AS gift_cost--撞击王者送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =1180
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =1180
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =1180
        AND money_sum >0
      GROUP BY 1)t0
   GROUP BY 1)t3 ON t1.date = t3.date
ORDER BY 1