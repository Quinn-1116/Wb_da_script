
SELECT t2.distinct_id,
       max(CASE WHEN t2.gameSubType = '1' THEN sub_num ELSE 0 END) `新手场局数`,
       max(CASE WHEN t2.gameSubType = '2' THEN sub_num ELSE 0 END) `躲猫猫局数`,
       max(CASE WHEN t2.gameSubType = '3' THEN sub_num ELSE 0 END) `进阶场局数`,
       max(CASE WHEN t2.gameSubType = '4' THEN sub_num ELSE 0 END) `12人3狼场局数`,
       max(CASE WHEN t2.gameSubType = '5' THEN sub_num ELSE 0 END) `躲猫猫欢乐技能场`
FROM
  (SELECT distinct_id
   FROM events
   WHERE gameTypeId = 1800
     AND event = 'gameOver'
     AND gameSubType = '4'
     AND detail = 'temple'
     AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
   GROUP BY 1)t1
JOIN
  (SELECT distinct_id,
          gameSubType,
          count(distinct_id)AS sub_num
   FROM events
   WHERE gameTypeId = 1800
     AND event = 'gameOver'
     AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
GROUP BY 1



SELECT t2.distinct_id,
       max(CASE WHEN t2.gameSubType = '1' THEN sub_num ELSE 0 END) `新手场局数`,
       max(CASE WHEN t2.gameSubType = '2' THEN sub_num ELSE 0 END) `躲猫猫局数`,
       max(CASE WHEN t2.gameSubType = '3' THEN sub_num ELSE 0 END) `进阶场局数`,
       max(CASE WHEN t2.gameSubType = '4' THEN sub_num ELSE 0 END) `12人3狼场局数`,
       max(CASE WHEN t2.gameSubType = '5' THEN sub_num ELSE 0 END) `躲猫猫欢乐技能场`
FROM
  (SELECT t1.distinct_id
   FROM
     (SELECT date,distinct_id
      FROM events
      WHERE gameTypeId = 1800
        AND event = 'gameOver'
        AND gameSubType = '4'
        AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
      GROUP BY 1,
               2)t1
   LEFT JOIN
     (SELECT date,distinct_id
      FROM events
      WHERE gameTypeId = 1800
        AND event = 'gameOver'
        AND gameSubType = '4'
        AND detail = 'temple'
        AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
      GROUP BY 1,
               2)t2 ON t1.date = t2.date
   AND t1.distinct_id = t2.distinct_id
   WHERE t2.distinct_id IS NULL
   GROUP BY 1) t1
JOIN
  (SELECT distinct_id,
          gameSubType,
          count(distinct_id)AS sub_num
   FROM events
   WHERE gameTypeId = 1800
     AND event = 'gameOver'
     AND date BETWEEN '2021-02-02' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t2 ON t1.distinct_id = t2.distinct_id
GROUP BY 1