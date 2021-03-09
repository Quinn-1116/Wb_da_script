--打开了弹窗的用户的游戏时长
SELECT t2.date,
       t2.distinct_id,
       t2.game_duration
FROM
  (SELECT t1.date,
          t1.distinct_id
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'register'
        AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 2 DAY
        AND appId IN ('20014',
                      '30015')
      GROUP BY 1,
               2) t1
   JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'advClick'
        AND button_name = 'adv'
        AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 2 DAY
        AND adv_id = 'b_killer_newuserlead_201217'
        AND appId IN ('20014',
                      '30015')
      GROUP BY 1,
               2)t2 ON t1.date = t2.date
   AND t1.distinct_id = t2.distinct_id
   GROUP BY 1,
            2) t1
JOIN
  (SELECT date,distinct_id,
               sum(duration/60000)AS game_duration
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2021-01-01' AND CURRENT_DATE() - interval 1 DAY
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
AND t1.date = t2.date



--关闭了弹窗的用户的游戏时长
SELECT t2.date,
       t2.distinct_id,
       t2.game_duration
FROM
  (SELECT t1.date, t1.distinct_id
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'register'
        AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 2 DAY
        AND appId IN ('20014',
                      '30015')
      GROUP BY 1,
               2) t1
   JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'advClick'
        AND button_name = 'exit'
        AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 2 DAY
        AND adv_id = 'b_killer_newuserlead_201217'
        AND appId IN ('20014',
                      '30015')
      GROUP BY 1,
               2)t2 ON t1.date = t2.date
   AND t1.distinct_id = t2.distinct_id
   GROUP BY 1,
            2) t1
JOIN
  (SELECT date,distinct_id,
               sum(duration/60000)AS game_duration
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2021-01-01' AND CURRENT_DATE() - interval 1 DAY
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
AND t1.date = t2.date



--没有触发弹窗的用户的游戏时长
SELECT t2.date,
       t2.distinct_id,
       t2.game_duration
FROM
  (SELECT t1.date, t1.distinct_id
   FROM
     (SELECT date,distinct_id,
                  appId
      FROM events
      WHERE event = 'register'
        AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 2 DAY
        AND appId IN ('20014',
                      '30015')
      GROUP BY 1,
               2,
               3) t1
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE event = 'advSend'
        AND date BETWEEN '2020-12-31' AND CURRENT_DATE() - interval 2 DAY
        AND adv_id = 'b_killer_newuserlead_201217'
        AND appId IN ('20014',
                      '30015')
        AND RESULT = 'pop-up'
      GROUP BY 1,
               2)t2 ON t1.date = t2.date
   AND t1.distinct_id = t2.distinct_id
   WHERE t2.distinct_id IS NULL
   GROUP BY 1,
            2) t1
JOIN
  (SELECT date,distinct_id,
               sum(duration/60000)AS game_duration
   FROM events
   WHERE event = 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2021-01-01' AND CURRENT_DATE() - interval 1 DAY
     AND appId IN ('20014',
                   '30015')
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
AND t1.date = t2.date