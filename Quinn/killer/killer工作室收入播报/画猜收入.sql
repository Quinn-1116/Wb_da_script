
SELECT t1.date,
       t1.draw_prop_cost,
       t2.gift_cost,
       t1.draw_prop_cost+t2.gift_cost AS draw
FROM
  (SELECT t0.date,
          sum(t0.draw_prop_cost)AS draw_prop_cost
   FROM
     (SELECT date,-sum(amount)/10 AS draw_prop_cost
      FROM events
      WHERE event = 'addDiamond'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND reason_diamond = 'buy_draw_item '
      GROUP BY 1
      UNION ALL SELECT date,-sum(amount)/1554 AS draw_prop_cost
      FROM events
      WHERE event = 'addItem'
        AND amount <0
        AND item_id = 1
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND reason = 'buy_draw_item'
      GROUP BY 1)t0
   GROUP BY 1)t1
LEFT JOIN
  (SELECT t0.date, sum(t0.gift_cost)AS gift_cost--画猜送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =101
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =101
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =101
        AND money_sum >0
      GROUP BY 1)t0
   GROUP BY 1)t2 ON t1.date = t2.date
ORDER BY 1