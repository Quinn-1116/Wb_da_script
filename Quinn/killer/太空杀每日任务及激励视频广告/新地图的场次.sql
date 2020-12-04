SELECT date,detail,
            count(DISTINCT match_id)
FROM events
WHERE event = 'gameOver'
  AND gameTypeId = 1800
  AND date BETWEEN current_date() - interval 1 DAY AND current_date()
GROUP BY 1,
         2
ORDER BY 1