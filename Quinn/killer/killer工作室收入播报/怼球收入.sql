
SELECT t0.date,
       sum(t0.gift_cost)AS ball--怼球送礼折算成收入

FROM
  (SELECT date,sum(diamond_sum)/10 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
     AND gametypeid = 1001
     AND diamond_sum >0
   GROUP BY 1
   UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
     AND gametypeid = 1001
     AND doudou_sum >0
   GROUP BY 1
   UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
     AND gametypeid = 1001
     AND money_sum >0
   GROUP BY 1)t0
GROUP BY 1
ORDER BY 1