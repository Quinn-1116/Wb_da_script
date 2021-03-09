
SELECT t1.date,
       t1.distinct_id,
       t1.gameSubType,
       t1.game_num/t2.ready_num
FROM
  (SELECT date,distinct_id,
               gameSubType,
               count(distinct_id)AS game_num
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND date BETWEEN '2020-12-16' AND current_date()
     AND time >= '2020-12-16 12:59:59'
   GROUP BY 1,
            2,
            3) t1
RIGHT JOIN
  (SELECT date,distinct_id,
               gameSubType,
               count(distinct_id)AS ready_num
   FROM events
   WHERE event = 'action'
     AND gameTypeId = 1800
     AND op_type = 'game_ready'
     AND time >= '2020-12-16 12:59:59'
     AND date BETWEEN '2020-12-16' AND current_date()
   GROUP BY 1,
            2,
            3)t2 ON t1.distinct_id = t2.distinct_id
AND t1.date = t2.date