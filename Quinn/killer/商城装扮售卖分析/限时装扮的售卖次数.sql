SELECT t1.`装扮名称`,
       t1.amount,
       count(t1.distinct_id)
FROM
  (SELECT date, distinct_id,
                goods_name AS `装扮名称`,
                amount,
                time
   FROM events
   WHERE event = 'exchange'
     AND currency_type = 'diamond'
     AND tag_id in(1153,1154,1155,1156,1158,1160,1161,1165)
     AND amount NOT in(388,488,600,720,900,1280)
     AND date BETWEEN '2020-11-28' AND '2020-12-18'
   GROUP BY 1,
            2,
            3,
            4,
            5
   UNION SELECT date, distinct_id,
                      CASE
                          WHEN goods_name = 'killer_hat_devil' THEN '小恶魔'
                          WHEN goods_name = 'killer_dress_suit' THEN '西装'
                          WHEN goods_name = 'killer_hat_bunny' THEN '幸运兔耳'
                          WHEN goods_name = 'killer_dress_uniforms' THEN '练功服'
                          WHEN goods_name = 'killer_dress_adventure' THEN '探险装'
                          WHEN goods_name = 'killer_hat_aperture' THEN '天使光环'
                          WHEN goods_name = 'killer_hat_pumpkin' THEN '南瓜帽'
                          WHEN goods_name = 'killer_hat_crown' THEN '小皇冠'
                          WHEN goods_name = 'killer_hat_hellowhair' THEN '时尚金发'
                          WHEN goods_name = 'killer_hat_flower' THEN '花盆'
                      END AS `装扮名称`,
                      amount,
                      time
   FROM events
   WHERE event = 'exchange'
     AND currency_type = 'diamond'
     AND amount NOT in(900,600)
     AND goods_name LIKE '%killer%'
     AND date BETWEEN '2020-10-31' AND '2020-11-27'
   GROUP BY 1,
            2,
            3,
            4,
            5)t1
GROUP BY 1 ,
         2