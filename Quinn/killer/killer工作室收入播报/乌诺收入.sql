SELECT t1.date,
       t1.uno_prop_cost,
       t2.gift_cost,
       t3.uno_commission,
       t4.uno_charge,
       t5.revenue,
       t1.uno_prop_cost+t2.gift_cost+t3.uno_commission+t4.uno_charge+t5.revenue AS uno
FROM
  (SELECT date,-sum(amount)/10 AS uno_prop_cost
   FROM events
   WHERE event = 'addDiamond'
     AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
     AND reason_diamond = 'uno_buy_suit'
   GROUP BY 1)t1
LEFT JOIN
  (SELECT t0.date, sum(t0.gift_cost)AS gift_cost--乌诺送礼折算成收入

   FROM
     (SELECT date,sum(diamond_sum)/10 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =1190
        AND diamond_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(doudou_sum)/1554 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
        AND gametypeid =1190
        AND doudou_sum >0
      GROUP BY 1
      UNION ALL SELECT date,sum(money_sum)/9774 gift_cost
      FROM events
      WHERE event = 'sendGift'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
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
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
      GROUP BY 1
      UNION ALL SELECT date,sum(cost_doudou)/9774 AS uno_commission--金币抽成

      FROM events
      WHERE event = 'gameOver'
        AND gameTypeId = 1190
        AND gameSubtype = '1'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
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
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
      GROUP BY 1
      UNION ALL SELECT date,sum(charge)/ 9774 AS charge--金币桌费

      FROM events
      WHERE event = 'gameOver'
        AND gameTypeId = 1190
        AND gameSubtype = '1'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
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
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
      GROUP BY 1)t1
   JOIN
     (SELECT date, sum(CASE WHEN currency_type = 'DOUDOU' THEN amount ELSE NULL END)/1554 AS doudou_revenue,
                   sum(CASE WHEN currency_type = 'MONEY' THEN amount ELSE NULL END)/9774 AS money_revenue
      FROM events--赢豆豆

      WHERE event = 'action'
        AND op_type = 'bet_guess_game'
        AND gameTypeId = 1190
        AND RESULT = 'win'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
      GROUP BY 1)t2 ON t1.date = t2.date
   JOIN
     (SELECT date, sum(CASE WHEN currency_type = 'DOUDOU' THEN charge ELSE NULL END)/1554 AS doudou_revenue,
                   sum(CASE WHEN currency_type = 'MONEY' THEN charge ELSE NULL END)/9774 AS money_revenue
      FROM events
      WHERE event = 'action'--赢豆豆抽成

        AND op_type = 'bet_guess_game'
        AND gameTypeId = 1190
        AND RESULT = 'win'
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 8 DAY
      GROUP BY 1)t3 ON t1.date = t3.date
   ORDER BY 1)t5 ON t1.date = t5.date
ORDER BY 1