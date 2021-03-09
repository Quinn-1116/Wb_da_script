--当前，用户可以在平台商城、二级大厅商城、游戏内小电脑购买装扮
 --已知：二级大厅商城：in_game_store，游戏内小电脑：in_game，平台商城：""

SELECT date,distinct_id,
            goods_name,
            currency_type,
            amount,
            POSITION,
            time
FROM events
WHERE event = 'exchange'
  AND tag_id IN (1153,
                 1154,
                 1155,
                 1156,
                 1158,
                 1160,
                 1161,
                 1165)
  AND date BETWEEN '2020-11-27' AND '2020-12-18'
GROUP BY 1,
         2,
         3,
         4,
         5,
         6,
         7
UNION
SELECT date, distinct_id,
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
                 WHEN goods_name = 'killer_hat_egg' THEN '煎蛋'
                 WHEN goods_name = 'killer_dress_plumber' THEN '管道工'
                 WHEN goods_name = 'killer_dress_doctor' THEN '白大褂'
                 WHEN goods_name = 'killer_hat_paper' THEN '一卷卷'
             END AS goods_name,
             currency_type,
             amount,
             POSITION,
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
         5,
         6,
         7