 --用户的覆盖率

SELECT t2.date,
       t2.total_game_num,
       t1.temple_game_num
FROM
  (SELECT date, count(DISTINCT distinct_id)AS temple_game_num
   FROM events
   WHERE gameTypeId = 1800
     AND event = 'gameStart'
     AND gameSubType = '4'
     AND detail= 'temple'
     AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
   GROUP BY 1)t1
JOIN
  (SELECT date, count(DISTINCT distinct_id)AS total_game_num
   FROM events
   WHERE gameTypeId = 1800
     AND event = 'gameStart'
     AND gameSubType = '4'
     AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
   GROUP BY 1) t2 ON t1.date = t2.date
ORDER BY 1 

--分场场次的覆盖率

SELECT t2.date,t2.total_game_num,
               t1.temple_game_num
FROM
  (SELECT date, count(DISTINCT match_id)AS temple_game_num
   FROM events
   WHERE gameTypeId = 1800
     AND event = 'gameStart'
     AND gameSubType = '4'
     AND detail= 'temple'
     AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
   GROUP BY 1) t1
JOIN
  (SELECT date, count(DISTINCT match_id)AS total_game_num
   FROM events
   WHERE gameTypeId = 1800
     AND event = 'gameStart'
     AND gameSubType = '4'
     AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
   GROUP BY 1)t2 ON t1.date = t2.date
order by 1


--进阶场各地图的回访率
SELECT t1.date,
       t1.detail,
       count(t1.distinct_id)AS detail_num,
       count(t2.distinct_id)AS detail_num_2,
       count(t2.distinct_id)/count(t1.distinct_id)as `回访率`
FROM
  (SELECT date,detail,
               distinct_id
   FROM events
   WHERE gameTypeId = 1800
     AND event = 'gameStart'
     AND gameSubType = '4'
     AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2,
            3)t1
LEFT JOIN
  (SELECT date,detail,
               distinct_id
   FROM events
   WHERE gameTypeId = 1800
     AND event = 'gameStart'
     AND gameSubType = '4'
     AND date BETWEEN '2021-02-02' AND current_date()
   GROUP BY 1,
            2,
            3)t2 ON t1.distinct_id = t2.distinct_id
AND t1.detail =t2.detail
AND datediff(t2.date,t1.date) = 1
GROUP BY 1,
         2
ORDER BY 1,
         2



SELECT t1.date,
       t1.detail,
       t1.detail_win_num,
       t2.detail_num,
       t1.detail_win_num/t2.detail_num as `好人胜率`
FROM
  (SELECT date,detail,
               count(DISTINCT match_id)AS detail_win_num
   FROM events
   WHERE gameTypeId = 1800
     AND event = 'gameOver'
     AND gameSubType = '4'
     AND game_character = 'crewmate'
     AND game_result = 'win'
     AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t1
JOIN
  (SELECT date,detail,
               count(DISTINCT match_id)AS detail_num
   FROM events
   WHERE gameTypeId = 1800
     AND event = 'gameOver'
     AND gameSubType = '4'
     AND game_character = 'crewmate'
     AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
AND t1.detail = t2.detail
ORDER BY 1,
         2


SELECT date,detail,
            avg(duration)/60000 AS `单局平均时长`
FROM events
WHERE gameTypeId = 1800
  AND event = 'gameOver'
  AND gameSubType = '4'
  AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
GROUP BY 1,
         2
ORDER BY 1,
         2







