WITH BusyMonth AS (
  SELECT DATE_FORMAT(Date, '%Y-%m') as The_month
  FROM games
  GROUP BY The_month
  ORDER BY COUNT(*) DESC
  LIMIT 1
), GamesInBusyMonth AS (
  SELECT away AS Team, Date
  FROM games, BusyMonth
  WHERE DATE_FORMAT(games.Date, '%Y-%m') = BusyMonth.The_month
  UNION
  SELECT home AS Team, Date
  FROM games, BusyMonth
  WHERE DATE_FORMAT(games.Date, '%Y-%m') = BusyMonth.The_month
), TimeIntervals AS (
  SELECT Team,
         TIMESTAMPDIFF(MINUTE, LAG(Date) OVER (PARTITION BY Team ORDER BY Date), Date) as TimeDifference
  FROM GamesInBusyMonth
)
SELECT Team, BusyMonth.The_month, TIME_FORMAT(SEC_TO_TIME(MIN(TimeDifference) * 60), '%H:%i') as time_interval
FROM TimeIntervals, BusyMonth
WHERE TimeDifference IS NOT NULL
GROUP BY Team, BusyMonth.The_month
ORDER BY Team;
