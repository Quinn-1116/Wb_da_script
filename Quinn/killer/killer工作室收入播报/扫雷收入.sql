
SELECT t1.date,
       t1.mine_prop_cost,
       t2.gift_cost,
       t1.mine_prop_cost+t2.gift_cost AS mine
FROM
  (SELECT t0.date,
          sum(t0.mine_prop_cost)AS mine_prop_cost
   FROM
     (SELECT date,-sum(amount)/10 AS mine_prop_cost
      FROM events
      WHERE event = 'addDiamond'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND reason_diamond in('buy_ming_flag','buy_mine_prop','buy_mine_table','buy_mine_gift_bag')
      GROUP BY 1
      UNION ALL SELECT date,-sum(amount)/1554 AS mine_prop_cost
      FROM events
      WHERE event = 'addItem'
        AND amount <0
        AND item_id = 1
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND reason in('buy_ming_flag','buy_mine_prop','buy_mine_table','buy_mine_gift_bag')
      GROUP BY 1
      UNION ALL SELECT date,-sum(amount)/9774 AS mine_prop_cost
      FROM events
      WHERE event = 'addMoney'
        AND amount <0
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND reason in('buy_ming_flag','buy_mine_prop','buy_mine_table','buy_mine_gift_bag')
      GROUP BY 1)t0
   GROUP BY 1)t1
LEFT JOIN
  (SELECT t0.date, sum(t0.gift_cost)AS gift_cost--画猜送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =1160
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =1160
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =1160
        AND money_sum >0
      GROUP BY 1)t0
   GROUP BY 1)t2 ON t1.date = t2.date
ORDER BY 1