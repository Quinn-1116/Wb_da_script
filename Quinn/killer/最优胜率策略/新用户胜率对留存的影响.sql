SELECT t1.*,
       t2.total_game,
       t3.win_game,
       t3.win_game/t2.total_game
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'register'
     AND appId IN ('20014',
                   '30015')
     AND date BETWEEN '2020-10-20' AND current_date()- interval 1 DAY
   GROUP BY 1,
            2)t1
JOIN
  (SELECT date,distinct_id,
               count(distinct_id)AS total_game
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-10-20' AND current_date()- interval 1 DAY
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
JOIN
  (SELECT date,distinct_id,
               count(distinct_id)AS win_game
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND game_result = 'win'
     AND date BETWEEN '2020-10-20' AND current_date()- interval 1 DAY
   GROUP BY 1,
            2)t3 ON t2.date = t3.date
AND t2.distinct_id = t3.distinct_id
ORDER BY t1.date,t1.distinct_id