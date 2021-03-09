SELECT t3.date,
       t3.playerCount,
       t3.win_num,
       t4.player_match_num,
       t3.win_num/t4.player_match_num
FROM
  (SELECT t1.date,
          t1.playerCount,
          count(DISTINCT t1.match_id)AS win_num
   FROM
     (SELECT date,playerCount,
                  match_id
      FROM events
      WHERE event = 'gameStart'
        AND gameTypeId = 1800
        AND gameSubType = '3'
        AND game_character = 'crewmate'
        AND date BETWEEN current_date() - interval 14 DAY AND current_date()
      GROUP BY 1,
               2,
               3) t1
   JOIN
     (SELECT date, match_id
      FROM events
      WHERE event = 'gameOver'
        AND gameTypeId = 1800
        AND gameSubType = '3'
        AND game_result = 'win'
        AND game_character = 'crewmate'
        AND date BETWEEN current_date() - interval 14 DAY AND current_date()
      GROUP BY 1,
               2)t2 ON t1.date = t2.date
   AND t1.match_id = t2.match_id
   GROUP BY 1,
            2) t3
JOIN
  (SELECT date,playerCount,
               count(DISTINCT match_id)AS player_match_num
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND gameSubType = '3'
     AND date BETWEEN current_date() - interval 14 DAY AND current_date()
   GROUP BY 1,
            2) t4 ON t3.date = t4.date
AND t3.playerCount = t4.playerCount
ORDER BY 1,
         2