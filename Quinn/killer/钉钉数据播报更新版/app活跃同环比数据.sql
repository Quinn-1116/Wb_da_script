SELECT t4.date,
       t4.app_dau,
       t4.app_dnu,
       t4.app_dou,
       (t4.app_dau-t4.yesterday_app_dau)/t4.yesterday_app_dau AS app_dau_rate_1,
       (t4.app_dau- t4.last_week_app_dau)/t4.last_week_app_dau AS app_dau_rate_7,
       (t4.app_dnu - t4.yesterday_app_dnu)/t4.yesterday_app_dnu AS app_dnu_rate_1,
       (t4.app_dnu - t4.last_week_app_dnu)/t4.last_week_app_dnu AS app_dnu_rate_7,
       (t4.app_dou - t4.yesterday_app_dou)/t4.yesterday_app_dou AS app_dnu_rate_1,
       (t4.app_dou - t4.last_week_app_dou)/t4.last_week_app_dou AS app_dnu_rate_7
FROM
  (SELECT t3.* ,
          lead(t3.app_dau,1) over(
                                  ORDER BY t3.date DESC) AS yesterday_app_dau,
          lead(t3.app_dau,7) over(
                                  ORDER BY t3.date DESC) AS last_week_app_dau,
          lead(t3.app_dnu,1) over(
                                  ORDER BY t3.date DESC) AS yesterday_app_dnu,
          lead(t3.app_dnu,7) over(
                                  ORDER BY t3.date DESC) AS last_week_app_dnu,
          lead(t3.app_dou,1) over(
                                  ORDER BY t3.date DESC) AS yesterday_app_dou,
          lead(t3.app_dou,7) over(
                                  ORDER BY t3.date DESC) AS last_week_app_dou
   FROM
     (SELECT t1.date,
             t1.app_dnu,
             t2.app_dau,
             (t2.app_dau-t1.app_dnu)AS app_dou
      FROM
        (SELECT date,count(DISTINCT distinct_id)AS app_dnu--新用户

         FROM events
         WHERE event = 'register'
           AND appId IN ('20014',
                         '30015',
                         '20009')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1) t1
      JOIN
        (SELECT date,count(DISTINCT distinct_id)AS app_dau--日活用户

         FROM events
         WHERE event = 'login'
           AND appId IN ('20014',
                         '30015',
                         '20009')
           AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
         GROUP BY 1)t2 ON t1.date = t2.date)t3 LIMIT 1)t4