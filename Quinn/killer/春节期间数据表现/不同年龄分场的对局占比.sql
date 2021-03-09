
SELECT t1.date,
       t1.total_match_num,
       t2.ageType,
       t2.age_match_num
FROM
  (SELECT date,count(DISTINCT match_id)AS total_match_num
   FROM events
   WHERE event= 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2021-02-01' AND current_date() - interval 1 DAY
   GROUP BY 1)t1
JOIN
  (SELECT date,ageType,
               count(DISTINCT match_id)AS age_match_num
   FROM events
   WHERE event= 'gameOver'
     AND gameTypeId = 1800
     AND date BETWEEN '2021-02-01' AND current_date() - interval 1 DAY
   GROUP BY 1,
            2)t2 ON t1.date = t2.date
ORDER BY 1