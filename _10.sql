WITH starting_pitchers AS (
    SELECT p.Game AS game_id, p.Inning AS inning, p.Pitcher AS starting_pitcher_name
    FROM pitches p
    WHERE p.Inning = 'T1'
),
qualified_pitchers AS (
    SELECT pt.Game, pt.Team, pt.Pitcher_Id, pt.IP
    FROM pitchers pt
    JOIN starting_pitchers sp ON pt.Game = sp.game_id AND pt.Pitcher_Id LIKE CONCAT('%', sp.starting_pitcher_name, '%')
    WHERE pt.IP >= 5
),
winning_pitchers AS (
    SELECT qp.Game AS game_id, qp.Pitcher_Id AS pitcher_id
    FROM qualified_pitchers qp
    JOIN games g ON qp.Game = g.Game
    WHERE (g.home = qp.Team AND g.home_score > g.away_score) OR (g.away = qp.Team AND g.away_score > g.home_score)
),
pitcher_wins AS (
    SELECT wp.pitcher_id, COUNT(wp.game_id) AS win_count
    FROM winning_pitchers wp
    GROUP BY wp.pitcher_id
)
SELECT pl.Name, pw.win_count
FROM pitcher_wins pw
JOIN players pl ON pl.Id = pw.pitcher_id
ORDER BY pw.win_count DESC
LIMIT 5;
