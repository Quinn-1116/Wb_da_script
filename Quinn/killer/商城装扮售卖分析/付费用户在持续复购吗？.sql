--拥有永久装扮的玩家还会购买新装扮吗？

SELECT t1.date,
       t1.distinct_id,
       t1.`装扮名称`,
       t1.amount,
       t2.date,
       t2.`装扮名称`,
       t2.amount
FROM
  (SELECT date, distinct_id,
                goods_name AS `装扮名称`,
                amount
   FROM events
   WHERE event = 'exchange'
     AND currency_type = 'diamond'
     AND tag_id in(1153,1154,1155,1156,1158,1160,1161,1165)
     AND amount in(388,488,600,720,900,1280)
     AND date BETWEEN '2020-11-28' AND current_date()
   GROUP BY 1,
            2,
            3,
            4
   UNION SELECT date, distinct_id,
                      CASE
                          WHEN goods_name = 'killer_hat_hellowhair' THEN '时尚金发'
                          WHEN goods_name = 'killer_hat_crown' THEN '小皇冠'
                          WHEN goods_name = 'killer_hat_aperture' THEN '天使光环'
                          WHEN goods_name = 'killer_dress_adventure' THEN '探险装'
                          WHEN goods_name = 'killer_hat_flower' THEN '花盆'
                      END AS "装扮名称",
                      amount
   FROM events
   WHERE event = 'exchange'
     AND currency_type = 'diamond'
     AND amount in(900,600)
     AND goods_name LIKE '%killer%'
     AND date BETWEEN '2020-10-31' AND '2020-11-27'
   GROUP BY 1,
            2,
            3,
            4) t1
LEFT JOIN



  (SELECT date, distinct_id,
                goods_name AS `装扮名称`,
                amount
   FROM events
   WHERE event = 'exchange'
     AND currency_type = 'diamond'
     AND tag_id in(1153,1154,1155,1156,1158,1160,1161,1165)
     AND amount NOT in(388,488,600,720,900,1280)
     AND date BETWEEN '2020-11-28' AND current_date()
   GROUP BY 1,
            2,
            3,
            4
   UNION ALL SELECT date, distinct_id,
                          CASE
                              WHEN goods_name = 'killer_hat_hellowhair' THEN '时尚金发'
                              WHEN goods_name = 'killer_hat_crown' THEN '小皇冠'
                              WHEN goods_name = 'killer_hat_aperture' THEN '天使光环'
                              WHEN goods_name = 'killer_dress_adventure' THEN '探险装'
                              WHEN goods_name = 'killer_hat_flower' THEN '花盆'
                          END AS "装扮名称",
                          amount
   FROM events
   WHERE event = 'exchange'
     AND currency_type = 'diamond'
     AND amount NOT in(900,600)
     AND goods_name LIKE '%killer%'
     AND date BETWEEN '2020-10-31' AND '2020-11-27'
   GROUP BY 1,
            2,
            3,
            4)t2 ON t1.distinct_id = t2.distinct_id
AND datediff(t2.date,t1.date)>=0
ORDER BY 1