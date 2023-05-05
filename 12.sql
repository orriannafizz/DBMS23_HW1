DROP TABLE IF EXISTS relief_pitchers;

CREATE TEMPORARY TABLE relief_pitchers AS (
    SELECT
        Pitcher_Id,
        COUNT(DISTINCT Game) AS num_starts
    FROM
        pitchers
    GROUP BY
        Pitcher_Id
    HAVING
        num_starts <= 10
);

DROP TABLE IF EXISTS relief_pitcher_stats;

CREATE TEMPORARY TABLE relief_pitcher_stats AS (
    SELECT
        p.Pitcher_Id,
        players.Name,
        SUM(IP) AS total_innings,
        IF(SUM(IP) = 0, NULL, SUM(ER) / SUM(IP) * 9) AS ERA,
        IF(SUM(IP) = 0, NULL, (SUM(H) + SUM(BB)) / SUM(IP)) AS WHIP,
        IF(SUM(IP) = 0, NULL, (SUM(K) / SUM(IP)) * 9) AS K_per_9
    FROM
        pitchers p
    JOIN
        relief_pitchers rp ON p.Pitcher_Id = rp.Pitcher_Id
    JOIN
        players ON players.Id = p.Pitcher_Id
    GROUP BY
        p.Pitcher_Id
);
WITH ranked_relief_pitchers AS (
    SELECT
        Pitcher_Id,
        Name,
        ERA,
        WHIP,
        K_per_9,
        RANK() OVER (ORDER BY ERA ASC) AS ERA_rank,
        RANK() OVER (ORDER BY WHIP ASC) AS WHIP_rank,
        RANK() OVER (ORDER BY K_per_9 DESC) AS K_per_9_rank
    FROM
        relief_pitcher_stats
),
overall_ranked_pitchers AS (
    SELECT
        *,
        (ERA_rank + WHIP_rank + K_per_9_rank) AS overall_rank
    FROM
        ranked_relief_pitchers
)
SELECT
    Pitcher_Id,
    Name,
    ERA,
    WHIP,
    K_per_9
FROM
    overall_ranked_pitchers
ORDER BY
    overall_rank ASC
LIMIT 1;
