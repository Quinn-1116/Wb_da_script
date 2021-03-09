SELECT t2.date,
       t2.prop_cost,
       t3.gift_cost,
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
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
      GROUP BY 1
      UNION ALL SELECT date, sum(amount)/9774 AS spy_store_diamond
      FROM events
      WHERE event = 'exchange'
        AND currency_type = 'gold'
        AND goods_id =5901
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
      GROUP BY 1)t1
   GROUP BY 1)t2
LEFT JOIN
  (SELECT t0.date, sum(t0.gift_cost)AS gift_cost--剧本杀送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =1150
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =1150
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =1150
        AND money_sum >0
      GROUP BY 1)t0
   GROUP BY 1)t3 ON t2.date = t3.date
ORDER BY 1