SELECT date,CASE
                WHEN appId IN ('10001',
                               '10002') THEN '主包'
                ELSE '单包'
            END AS appId ,
            count(DISTINCT distinct_id)AS game_dau
FROM events
WHERE event = 'gameOver'
  AND appId IN ('10001',
                '10002',
                '20014',
                '30015')
  AND date BETWEEN '2021-01-28' AND '2021-02-28'
  and gameTypeId = 1800
GROUP BY 1,
         2
ORDER BY 1,2



SELECT date,CASE
                WHEN appId IN ('10001',
                               '10002') THEN '主包'
                ELSE '单包'
            END AS appId ,
            count(DISTINCT distinct_id)AS game_dau
FROM events
WHERE event = 'gameStart'
  AND appId IN ('10001',
                '10002',
                '20014',
                '30015')
  AND date BETWEEN '2021-01-28' AND '2021-02-28'
    and gameTypeId = 1800
    and game_played = 0
GROUP BY 1,
         2
ORDER BY 1 ,
         3 DESC