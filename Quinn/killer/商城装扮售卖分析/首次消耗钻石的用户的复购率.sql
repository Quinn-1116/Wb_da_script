SELECT t3.amount,
       count(DISTINCT t3.distinct_id)AS user_num,
       count(DISTINCT t4.distinct_id)AS pay_reten_num
FROM
  (SELECT t2.date,
          t2.distinct_id,
          t2.goods_name,
          t2.amount,
          t2.time
   FROM
     (SELECT t1.date,
             t1.distinct_id,
             t1.goods_name,
             t1.amount,
             t1.time,
             row_number()over(partition BY t1.distinct_id
                              ORDER BY t1.time)AS time_rank
      FROM
        (SELECT date, distinct_id,
                      goods_name ,
                      amount,
                      time
         FROM events
         WHERE event = 'exchange'
           AND currency_type = 'diamond'
           AND tag_id in(1153,1154,1155,1156,1158,1160,1161,1165)
           AND date BETWEEN '2020-11-28' AND '2020-12-18'
         GROUP BY 1,
                  2,
                  3,
                  4,
                  5
         UNION SELECT date, distinct_id,
                            CASE WHEN goods_name = 'killer_hat_devil' THEN '小恶魔' WHEN goods_name = 'killer_dress_suit' THEN '西装' WHEN goods_name = 'killer_hat_bunny' THEN '幸运兔耳' WHEN goods_name = 'killer_dress_uniforms' THEN '练功服' WHEN goods_name = 'killer_dress_adventure' THEN '探险装' WHEN goods_name = 'killer_hat_aperture' THEN '天使光环' WHEN goods_name = 'killer_hat_pumpkin' THEN '南瓜帽' WHEN goods_name = 'killer_hat_crown' THEN '小皇冠' WHEN goods_name = 'killer_hat_hellowhair' THEN '时尚金发' WHEN goods_name = 'killer_hat_flower' THEN '花盆' WHEN goods_name = 'killer_hat_egg' THEN '煎蛋' WHEN goods_name = 'killer_dress_plumber' THEN '管道工' WHEN goods_name = 'killer_dress_doctor' THEN '白大褂' WHEN goods_name = 'killer_hat_paper' THEN '一卷卷' END AS goods_name,
amount,
time
         FROM events
WHERE event = 'exchange'
AND currency_type = 'diamond'
AND goods_name LIKE '%killer%'
AND date BETWEEN '2020-10-31' AND '2020-11-27'
         GROUP BY 1,
                  2,
                  3,
                  4,
                  5)t1)t2
WHERE t2.time_rank = 1) t3
LEFT JOIN
(SELECT date,distinct_id,
         time
FROM events
WHERE event = 'pay'
AND date BETWEEN '2020-10-31' AND current_date()
AND appId in('20014','30015','10001','10002')
GROUP BY 1,
     2,
     3)t4 ON t3.distinct_id = t4.distinct_id
AND t4.time > t3.time
AND datediff(t4.date,t3.date) BETWEEN 0 AND 6
GROUP BY 1
ORDER BY 2 DESC