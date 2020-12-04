SELECT date, playerCount,
             count(DISTINCT match_id)
FROM events
WHERE event = 'gameStart'
  AND gameTypeId = 1800
  AND date BETWEEN '2020-10-20' AND current_date()- interval 1 DAY
GROUP BY 1,
         2
ORDER BY 1,
         2