SELECT date, detail,
             reason,
             count(DISTINCT match_id)AS crew_win
FROM events
WHERE event = 'gameOver'
  AND gameTypeId = 1800
  AND game_result = 'win'
  AND game_character = 'crewmate'
  AND date BETWEEN current_date() - interval 1 DAY AND current_date()
GROUP BY 1,
         2,
         3
ORDER BY 1,
         2,3