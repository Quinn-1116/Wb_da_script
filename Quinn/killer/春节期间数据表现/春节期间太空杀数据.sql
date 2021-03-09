SELECT t1.date,
       t7.app_dau,
       t8.app_dnu,
       t1.game_dau,
       t2.game_dnu,
       t3.game_r1,
       t4.avg_gameDuration,
       t5.avg_game_num,
       t6.pay,
       t6.pay_num,
       t6.arppu,
       t6.pay/t7.app_dau AS arpu
FROM
  (SELECT date,count(DISTINCT distinct_id)AS game_dau
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND date BETWEEN '2021-01-28' AND '2021-02-28'
   GROUP BY 1
   ORDER BY 1)t1
JOIN
  (SELECT date,count(DISTINCT distinct_id)AS app_dau
   FROM events
   WHERE event = 'login'
     AND appId IN ('20014',
                   '30015')
     AND date BETWEEN '2021-01-28' AND '2021-02-28'
   GROUP BY 1
   ORDER BY 1)t7 ON t1.date = t7.date
JOIN
  (SELECT date,count(DISTINCT distinct_id)AS app_dnu
   FROM events
   WHERE event = 'register'
     AND appId IN ('20014',
                   '30015')
     AND date BETWEEN '2021-01-28' AND '2021-02-28'
   GROUP BY 1
   ORDER BY 1)t8 ON t1.date = t8.date
JOIN
  (SELECT date,count(DISTINCT distinct_id)AS game_dnu
   FROM events
   WHERE event = 'gameStart'
     AND gameTypeId = 1800
     AND game_played = 0
     AND date BETWEEN '2021-01-28' AND '2021-02-28'
   GROUP BY 1
   ORDER BY 1)t2 ON t1.date = t2.date
JOIN
  (SELECT t1.date, count(t2.distinct_id)/ count(t1.distinct_id) AS game_r1
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'gameStart'
        AND gameTypeId = 1800
        AND game_played = 0
        AND date BETWEEN '2021-01-28' AND '2021-02-28
'
      GROUP BY 1,
               2)t1
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'gameStart'
        AND gameTypeId = 1800
        AND date BETWEEN '2021-01-28' AND '2021-02-28
'
      GROUP BY 1,
               2)t2 ON t1.distinct_id = t2.distinct_id
   AND datediff(t2.date,t1.date) = 1
   GROUP BY 1)t3 ON t1.date = t3.date
JOIN
  (SELECT date, sum(duration)/count(distinct_id)AS avg_gameDuration
   FROM
     (SELECT date, distinct_id,
                   sum(duration/60000)AS duration
      FROM events
      WHERE event = 'gameOver'
        AND gameTypeId = 1800
        AND date BETWEEN '2021-01-28' AND '2021-02-28
'
      GROUP BY 1,
               2)t1
   GROUP BY 1)t4 ON t1.date = t4.date
JOIN
  (SELECT date, sum(game_num)/count(distinct_id)AS avg_game_num
   FROM
     (SELECT date, distinct_id,
                   count(distinct_id)AS game_num
      FROM events
      WHERE event = 'gameOver'
        AND gameTypeId = 1800
        AND date BETWEEN '2021-01-28' AND '2021-02-28
'
      GROUP BY 1,
               2)t1
   GROUP BY 1)t5 ON t1.date = t5.date
JOIN
  (SELECT date,sum(pay)AS pay,
               sum(pay)/count(DISTINCT distinct_id)AS arppu,
               count(DISTINCT distinct_id) AS pay_num
   FROM events
   WHERE event = 'pay'
     AND date BETWEEN '2021-01-28' AND '2021-02-28'
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1)t6 ON t1.date = t6.date
ORDER BY 1