
SELECT t0.date,
       sum(t0.gift_cost)AS other--送礼折算成收入

FROM
  (SELECT date,sum(diamond_sum)/10 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
     AND gametypeid in(1215,1214,1212,1220,1208,1202,1219,1210,1213,1201,1200,1224,1203)
     AND diamond_sum >0
   GROUP BY 1
   UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
     AND gametypeid in(1215,1214,1212,1220,1208,1202,1219,1210,1213,1201,1200,1224,1203)
     AND doudou_sum >0
   GROUP BY 1
   UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
   FROM events
   WHERE event = 'sendGift'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
     AND gametypeid in(1215,1214,1212,1220,1208,1202,1219,1210,1213,1201,1200,1224,1203)
     AND money_sum >0
   GROUP BY 1)t0
GROUP BY 1
ORDER BY 1