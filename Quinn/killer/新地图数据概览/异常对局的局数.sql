
SELECT count(*)
FROM
  (SELECT t1.match_id--双方都获胜的match_id·

   FROM
    
   JOIN
     (SELECT date,match_id
      FROM events
      WHERE event = 'gameOver'
        AND gameTypeId = 1800
        AND game_result = 'win'
        AND game_character = 'impostor'
        AND date BETWEEN current_date() - interval 2 DAY AND current_date()
      GROUP BY 1,
               2)t2 ON t1.date = t2.date
   AND t1.match_id = t2.match_id
   UNION SELECT t3.match_id
   FROM
     (SELECT date,match_id--双方都输的match_id

      FROM events
      WHERE event = 'gameOver'
        AND gameTypeId = 1800
        AND game_result = 'lose'
        AND game_character = 'crewmate'
        AND date BETWEEN current_date() - interval 2 DAY AND current_date()
      GROUP BY 1,
               2) t3
   JOIN
     (SELECT date, match_id
      FROM events
      WHERE event = 'gameOver'
        AND gameTypeId = 1800
        AND game_result = 'lose'
        AND game_character = 'impostor'
        AND date BETWEEN current_date() - interval 2 DAY AND current_date()
      GROUP BY 1,
               2)t4 ON t3.date = t4.date
   AND t3.match_id = t4.match_id) t5