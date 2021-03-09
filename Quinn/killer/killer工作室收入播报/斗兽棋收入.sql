
SELECT t1.date,
       t1.animal_prop_cost,
       t2.gift_cost,
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
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
      GROUP BY 1
      UNION ALL SELECT date,-sum(amount)/1554 AS animal_prop_cost
      FROM events
      WHERE event = 'addDiamond'
        AND amount <0
        AND reason = 'buy_animalchess'
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
        AND gametypeid = 1207
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid = 1207
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid = 1207
        AND money_sum >0
      GROUP BY 1)t0
   GROUP BY 1)t2 ON t1.date = t2.date
ORDER BY 1