--游戏新用户的留存

SELECT t10.date,
       t10.game_new_user_r1,
       t10.game_new_user_r1-t10.day_game_rate AS day_game_rate,
       t10.game_new_user_r1-t10.last_week_game_rate AS week_game_rate
FROM
  (SELECT t0.date,
          t0.game_new_user_r1,
          lead(t0.game_new_user_r1,1)over(
                                          ORDER BY t0.date DESC)AS day_game_rate,
          lead(t0.game_new_user_r1,7)over(
                                          ORDER BY t0.date DESC)AS last_week_game_rate
   FROM
     (SELECT t1.date,
             count(t2.distinct_id)/count(t1.distinct_id) game_new_user_r1
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND game_played = 0
           AND date BETWEEN current_date() - interval 9 DAY AND current_date() - interval 2 DAY
         GROUP BY 1,
                  2) t1
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t2 ON t1.distinct_id = t2.distinct_id
      AND datediff(t2.date,t1.date) = 1
      GROUP BY 1)t0 LIMIT 1)t10