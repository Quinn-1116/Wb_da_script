SELECT t1.date,
       t1.detail,
       t1.crew_win/t2.total
FROM
  (SELECT date, detail,
                count(DISTINCT match_id)AS crew_win
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND game_result = 'win'
     AND game_character = 'crewmate'
     AND date BETWEEN current_date() - interval 1 DAY AND current_date()
   GROUP BY 1,
            2) t1
LEFT JOIN
  (SELECT date, detail,
                count(DISTINCT match_id)AS total
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN current_date() - interval 1 DAY AND current_date()
   GROUP BY 1,
            2) t2 ON t1.date= t2.date
AND t1.detail= t2.detail
ORDER BY 1