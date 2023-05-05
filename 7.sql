WITH Team_Win_Loss AS (
    SELECT 
        home AS Team,
        SUM(CASE WHEN home_score > away_score THEN 1 ELSE 0 END) AS Wins,
        SUM(CASE WHEN home_score < away_score THEN 1 ELSE 0 END) AS Losses
    FROM games
    WHERE YEAR(Date) = 2021
    GROUP BY home
    UNION ALL
    SELECT 
        away AS Team,
        SUM(CASE WHEN home_score < away_score THEN 1 ELSE 0 END) AS Wins,
        SUM(CASE WHEN home_score > away_score THEN 1 ELSE 0 END) AS Losses
    FROM games
    WHERE YEAR(Date) = 2021
    GROUP BY away
),
Team_Win_rate AS (
    SELECT
        Team,
        SUM(Wins) / (SUM(Wins) + SUM(Losses)) AS Win_rate
    FROM Team_Win_Loss
    GROUP BY Team
    ORDER BY Win_rate DESC
    LIMIT 5
),
Hitter_Stats AS (
    SELECT
        h.Hitter_Id,
        p.Name AS Hitter,
        t.Team,
        SUM(h.AB) AS tol_hit,
        SUM(h.H) AS Total_Hits
    FROM hitters h
    JOIN games g ON h.Game = g.Game
    JOIN players p ON h.Hitter_Id = p.Id
    JOIN Team_Win_rate t ON (h.Team = t.Team)
    WHERE YEAR(g.Date) = 2021 AND h.AB > 0
    GROUP BY h.Hitter_Id, p.Name, t.Team
    HAVING tol_hit > 100
)
SELECT
    hs.Team,
    hs.Hitter,
    ROUND(AVG(hs.Total_Hits / hs.tol_hit), 4) AS avg_hit_rate,
    SUM(hs.tol_hit) AS tol_hit,
    twp.Win_rate
FROM Hitter_Stats hs
JOIN Team_Win_rate twp ON hs.Team = twp.Team
GROUP BY hs.Team, hs.Hitter, twp.Win_rate
ORDER BY twp.Win_rate DESC;
