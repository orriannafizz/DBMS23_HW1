WITH team_hit_rates AS (
    SELECT
        g.Game,
        h.Team,
        SUM(h.H) / SUM(h.AB) AS hit_rate
    FROM
        hitters h
    JOIN
        games g ON h.Game = g.Game
    WHERE
        YEAR(g.Date) = 2021
    GROUP BY
        g.Game, h.Team
),
game_hit_rate_diffs AS (
    SELECT
        t1.Game,
        ABS(t1.hit_rate - t2.hit_rate) AS hit_rate_difference,
        CASE
            WHEN t1.hit_rate > t2.hit_rate AND g.away_score > g.home_score THEN 1
            WHEN t1.hit_rate < t2.hit_rate AND g.away_score < g.home_score THEN 1
            ELSE 0
        END AS higher_hit_rate_won
    FROM
        team_hit_rates t1
    JOIN
        team_hit_rates t2 ON t1.Game = t2.Game AND t1.Team != t2.Team
    JOIN
        games g ON t1.Game = g.Game
    WHERE
        t1.Team = g.away
),
rounded_diffs AS (
    SELECT
        FLOOR(hit_rate_difference * 100) / 100 AS hit_rate_diff,
        SUM(higher_hit_rate_won) AS wins,
        COUNT(*) AS total_games
    FROM
        game_hit_rate_diffs
    GROUP BY
        hit_rate_diff
)
SELECT
    hit_rate_diff,
    ROUND(wins / total_games, 4) AS win_rate
FROM
    rounded_diffs
HAVING
    win_rate > 0.95
ORDER BY
    hit_rate_diff ASC
LIMIT 1;
