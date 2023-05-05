SELECT p.Pitcher_Id, pl.Name, ROUND(SUM(p.IP), 1) as Total_Innings
FROM pitchers p
JOIN games g ON p.Game = g.Game
JOIN players pl ON p.Pitcher_Id = pl.Id
WHERE g.Date BETWEEN '2021-04-01' AND '2021-11-30'
GROUP BY p.Pitcher_Id, pl.Name
ORDER BY Total_Innings DESC
LIMIT 3;

