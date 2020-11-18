--付费人数、付费金额、arpu（每用户平均收入）、arppu（每付费用户平均收入）、付费率（付费用户数/dau）

SELECT t3.*,
       lead(t3.`付费人数`,1)over(
                             ORDER BY t1.date DESC) AS `前一日付费人数`,
       lead(t3.`付费人数`,7)over(
                             ORDER BY t1.date DESC) AS `前7日付费人数`,
       lead(t3.`付费金额`,1)over(
                             ORDER BY t1.date DESC) AS `前一日付费金额`,
       lead(t3.`付费金额`,7)over(
                             ORDER BY t1.date DESC) AS `前7日付费金额`,
       lead(t3.`付费率`,1)over(
                            ORDER BY t1.date DESC) AS `前一日付费率`,
       lead(t3.`付费率`,7)over(
                            ORDER BY t1.date DESC) AS `前7日付费率`,
       lead(t3.`arpu`,1)over(
                             ORDER BY t1.date DESC) AS `前一日arpu`,
       lead(t3.`arpu`,7)over(
                             ORDER BY t1.date DESC) AS `前7日arpu`,
       lead(t3.`arpu`,1)over(
                             ORDER BY t1.date DESC) AS `前一日arpu`,
       lead(t3.`arpu`,7)over(
                             ORDER BY t1.date DESC) AS `前7日arpu`,
       lead(t3.arppu,1)over(
                            ORDER BY t1.date DESC) AS `前一日arppu`,
       lead(t3.arppu,7)over(
                            ORDER BY t1.date DESC) AS `前7日arppu`
FROM
  (SELECT t1.date,
          t2.`付费人数`,
          t2.`付费金额`,
          t2.`付费人数`/t1.`活跃用户数`AS `付费率`,
          t2.`付费金额`/t1.`活跃用户数` AS `arpu`,
          t2.arppu
   FROM
     (SELECT date,count(DISTINCT distinct_id)AS `活跃用户数`
      FROM events
      WHERE event = 'login'
        AND appId in('20014', '30015')
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1)t1
   JOIN
     (SELECT date,count(DISTINCT distinct_id) AS `付费人数`,
                  sum(pay)AS `付费金额`,
                  sum(pay)/count(DISTINCT distinct_id) AS arppu
      FROM events
      WHERE event = 'pay'
        AND appId in('20014','30015')
        AND date BETWEEN current_date() - interval 8 DAY AND current_date() - interval 1 DAY
      GROUP BY 1)t2 ON t1.date = t2.date)t3