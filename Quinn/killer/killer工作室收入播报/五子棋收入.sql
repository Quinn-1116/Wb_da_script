
SELECT t1.date,
       t1.wuzi_prop_cost,
       t2.gift_cost,
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
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
      GROUP BY 1
      UNION ALL SELECT date, sum(amount)/9774 AS wuzi_prop_cost
      FROM events
      WHERE event = 'exchange'
        AND currency_type = 'gold'
        AND goods_id IN (700,
                         701)
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
      GROUP BY 1)t0
   GROUP BY 1)t1
JOIN
  (SELECT t0.date, sum(t0.gift_cost)AS gift_cost--五子棋送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid = 1206
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid = 1206
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid = 1206
        AND money_sum >0
      GROUP BY 1)t0
   GROUP BY 1)t2 ON t1.date = t2.date
ORDER BY 1