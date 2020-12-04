SELECT t5.date,
       t5.game_dnu,
       t5.`注册-游戏转化率` AS regist_to_gameRate,
       (t5.game_dnu-t5.yesterday_game_dnu)/t5.yesterday_game_dnu AS game_dnu_1,
       (t5.game_dnu-t5.last_week_game_dnu)/t5.last_week_game_dnu AS game_dnu_7,
       t5.`注册-游戏转化率`-yesterday_game_rate AS game_rate_1,
       t5.`注册-游戏转化率`-last_week_game_rate AS game_rate_7
FROM
  (SELECT t4.*,
          lead(t4.dnu,1)over(
                             ORDER BY t4.date DESC) AS yesterday_game_dnu,
          lead(t4.dnu,7)over(
                             ORDER BY t4.date DESC) AS last_week_game_dnu,
          lead(t4.`注册-游戏转化率`,1)over(
                                    ORDER BY t4.date DESC) AS yesterday_game_rate,
          lead(t4.`注册-游戏转化率`,7)over(
                                    ORDER BY t4.date DESC) AS last_week_game_rate
   FROM
     (SELECT t1.date,
             count(t1.distinct_id) AS dnu,
             count(t2.distinct_id) AS login_dnu,
             count(t2.distinct_id)/count(t1.distinct_id) AS `注册-登录转化率`,
             count(t3.distinct_id) AS game_dnu,
             count(t3.distinct_id)/count(t1.distinct_id)AS `注册-游戏转化率`
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'register'
           AND appId in('20014','30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t1
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'login'
           AND appId in('20014','30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t2 ON t1.date = t2.date
      AND t1.distinct_id = t2.distinct_id
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND game_played = 0
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t3 ON t1.date = t3.date
      AND t1.distinct_id = t3.distinct_id
      GROUP BY 1)t4 LIMIT 1) t5




SELECT t5.date,
       t5.game_dnu,
       t5.`注册-游戏转化率` AS ios_dnu_gamerate,
       (t5.game_dnu-t5.yesterday_game_dnu)/t5.yesterday_game_dnu AS game_dnu_1,
       (t5.game_dnu-t5.last_week_game_dnu)/t5.last_week_game_dnu AS game_dnu_7,
       t5.`注册-游戏转化率`-yesterday_game_rate AS game_rate_1,
       t5.`注册-游戏转化率`-last_week_game_rate AS game_rate_7
FROM
  (SELECT t4.*,
          lead(t4.dnu,1)over(
                             ORDER BY t4.date DESC) AS yesterday_game_dnu,
          lead(t4.dnu,7)over(
                             ORDER BY t4.date DESC) AS last_week_game_dnu,
          lead(t4.`注册-游戏转化率`,1)over(
                                    ORDER BY t4.date DESC) AS yesterday_game_rate,
          lead(t4.`注册-游戏转化率`,7)over(
                                    ORDER BY t4.date DESC) AS last_week_game_rate
   FROM
     (SELECT t1.date,
             count(t1.distinct_id) AS dnu,
             count(t2.distinct_id) AS login_dnu,
             count(t2.distinct_id)/count(t1.distinct_id) AS `注册-登录转化率`,
             count(t3.distinct_id) AS game_dnu,
             count(t3.distinct_id)/count(t1.distinct_id)AS `注册-游戏转化率`
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'register'
           AND appId in('30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t1
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'login'
           AND appId in('30015')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t2 ON t1.date = t2.date
      AND t1.distinct_id = t2.distinct_id
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND game_played = 0
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t3 ON t1.date = t3.date
      AND t1.distinct_id = t3.distinct_id
      GROUP BY 1)t4 LIMIT 1) t5






  SELECT t5.date,
       t5.game_dnu,
       t5.`注册-游戏转化率` as android_dnu_gamerate,
       (t5.game_dnu-t5.yesterday_game_dnu)/t5.yesterday_game_dnu AS game_dnu_1,
       (t5.game_dnu-t5.last_week_game_dnu)/t5.last_week_game_dnu AS game_dnu_7,
       t5.`注册-游戏转化率`-yesterday_game_rate AS game_rate_1,
       t5.`注册-游戏转化率`-last_week_game_rate AS game_rate_7
FROM
  (SELECT t4.*,
          lead(t4.dnu,1)over(
                             ORDER BY t4.date DESC) AS yesterday_game_dnu,
          lead(t4.dnu,7)over(
                             ORDER BY t4.date DESC) AS last_week_game_dnu,
          lead(t4.`注册-游戏转化率`,1)over(
                                    ORDER BY t4.date DESC) AS yesterday_game_rate,
          lead(t4.`注册-游戏转化率`,7)over(
                                    ORDER BY t4.date DESC) AS last_week_game_rate
   FROM
     (SELECT t1.date,
             count(t1.distinct_id) AS dnu,
             count(t2.distinct_id) AS login_dnu,
             count(t2.distinct_id)/count(t1.distinct_id) AS `注册-登录转化率`,
             count(t3.distinct_id) AS game_dnu,
             count(t3.distinct_id)/count(t1.distinct_id)AS `注册-游戏转化率`
      FROM
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'register'
           AND appId in('20014')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t1
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'login'
           AND appId in('20014')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t2 ON t1.date = t2.date
      AND t1.distinct_id = t2.distinct_id
      LEFT JOIN
        (SELECT date,distinct_id
         FROM events
         WHERE event = 'gameStart'
           AND gameTypeId = 1800
           AND game_played = 0
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1,
                  2)t3 ON t1.date = t3.date
      AND t1.distinct_id = t3.distinct_id
      GROUP BY 1)t4 LIMIT 1) t5