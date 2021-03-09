SELECT t2.date,
       t2.distinct_id,
       t1.game_level,
       t1.date,
       datediff(t1.date, t2.date)AS date_gap
FROM
  (SELECT date,distinct_id,
               game_level,
               time
   FROM events
   WHERE event = 'upgrade'
     AND date BETWEEN '2020-11-30' AND current_date()
     AND gameTypeId = 1800
   GROUP BY 1,
            2,
            3,
            4) t1
RIGHT JOIN
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'register'
     AND date BETWEEN '2020-11-30' AND current_date()
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
ORDER BY 1,
         2,
         3