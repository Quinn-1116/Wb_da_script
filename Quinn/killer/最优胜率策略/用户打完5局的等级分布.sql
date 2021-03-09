
SELECT t1.date,
       t1.distinct_id,
       t2.game_level
FROM
  (SELECT date,distinct_id,
               match_id
   FROM events
   WHERE event = 'gameStart'
     AND game_played= 5
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-30' AND current_date()) t1
LEFT JOIN
  (SELECT date,distinct_id,
               game_level,
               match_id
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-11-30' AND current_date())t2 ON t1.date = t2.date
AND t1.distinct_id = t2.distinct_id
AND t1.match_id = t2.match_id