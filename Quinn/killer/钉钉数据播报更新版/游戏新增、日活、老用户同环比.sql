SELECT t10.date,
       t10.game_dau,
       (t10.game_dau-t10.yesterday_dau)/t10.yesterday_dau AS dau_day,
       (t10.game_dau-t10.last_week_dau)/t10.last_week_dau AS dau_week,

       t10.game_dnu,
       (t10.game_dnu-t10.yesterday_dnu)/t10.yesterday_dnu AS dnu_day,
       (t10.game_dnu-t10.last_week_dnu)/t10.last_week_dnu AS dnu_week,

       t10.game_dou,
       (t10.game_dou-t10.yesterday_dou)/t10.yesterday_dou AS dou_day,
       (t10.game_dou-t10.last_week_dou)/t10.last_week_dou AS dou_week
FROM
  (SELECT t0.date,
          t0.game_dau,
          lead(t0.game_dau,1)over(
                                  ORDER BY t0.date DESC)AS yesterday_dau,
          lead(t0.game_dau,7)over(
                                  ORDER BY t0.date DESC) AS last_week_dau,
          t0.game_dnu,
          lead(t0.game_dnu,1)over(
                                  ORDER BY t0.date DESC) AS yesterday_dnu,
          lead(t0.game_dnu,7)over(
                                  ORDER BY t0.date DESC) AS last_week_dnu,
          t0.game_dou,
          lead(t0.game_dou,1)over(
                                  ORDER BY t0.date DESC) AS yesterday_dou,
          lead(t0.game_dou,7)over(
                                  ORDER BY t0.date DESC) AS last_week_dou
   FROM
     (SELECT t1.date,
             t1.game_dnu,
             t2.game_dau,
             (t2.game_dau-t1.game_dnu)AS game_dou
      FROM
        (SELECT date,count(DISTINCT distinct_id)AS game_dnu--新用户

         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND game_played = 0
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1) t1
      JOIN
        (SELECT date,count(DISTINCT distinct_id)AS game_dau--日活用户

         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1)t2 ON t1.date = t2.date)t0 LIMIT 1) t10