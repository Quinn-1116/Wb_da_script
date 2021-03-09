
SELECT t2.date,
       count(t2.distinct_id)AS game_dnu
FROM
  (SELECT date,distinct_id
   FROM events
   WHERE event = 'login'
     AND appId IN ('20014',
                   '30015')
     AND date BETWEEN '2020-10-20' AND current_date()- interval 1 DAY
   GROUP BY 1,
            2)t1
LEFT JOIN
  (SELECT date,distinct_id,
               playerCount
   FROM events
   WHERE event = 'gameStart'
     AND game_played = 0
     AND date BETWEEN '2020-10-20' AND current_date()- interval 1 DAY
   GROUP BY 1,
            2,
            3)t2 ON t1.distinct_id = t2.distinct_id
AND t1.date = t2.date
GROUP BY 1
ORDER BY 1