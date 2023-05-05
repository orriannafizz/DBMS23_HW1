WITH games_20_21 AS(
        SELECT Game
        FROM games
        WHERE
            YEAR(Date) BETWEEN 2020 AND 2021
    ),
    games_20
     AS(
        SELECT Game
        FROM games
        WHERE
            YEAR(Date) = 2020
    ),
    games_21 AS(
        SELECT Game
        FROM games
        WHERE
            YEAR(Date) = 2021
    ),
    basicPitcher AS (
        SELECT
            DISTINCT p1.Pitcher_Id
        FROM pitchers p1
            INNER JOIN games_20
             g1 ON p1.Game = g1.Game
        WHERE EXISTS (
                SELECT 1
                FROM pitchers p2
                    INNER JOIN games_21 g2 ON p2.Game = g2.Game
                WHERE
                    p1.Pitcher_Id = p2.Pitcher_Id
            )
        GROUP BY p1.Pitcher_Id
        HAVING
            SUM(p1.IP) > 0
    ),
    pitcherValid AS (
        SELECT
            DISTINCT p.Pitcher_Id
        FROM pitchers p
            INNER JOIN games_20_21 g ON p.Game = g.Game
            INNER JOIN basicPitcher pb ON p.Pitcher_Id = pb.Pitcher_Id
        GROUP BY p.Pitcher_Id
        HAVING
            SUM(p.IP) > 50
    ),
    pitcherChanged AS (
        SELECT p.Pitcher_Id
        FROM pitchers p
            INNER JOIN games_20_21 g ON p.Game = g.Game
            INNER JOIN pitcherValid pv ON p.Pitcher_Id = pv.Pitcher_Id
        GROUP BY p.Pitcher_Id
        HAVING
            COUNT(DISTINCT p.Team) > 1
    ),
    pitcherUnchanged AS (
        SELECT p.Pitcher_Id
        FROM pitchers p
            INNER JOIN games_20_21 g ON p.Game = g.Game
            INNER JOIN pitcherValid pv ON p.Pitcher_Id = pv.Pitcher_Id
        GROUP BY p.Pitcher_Id
        HAVING
            COUNT(DISTINCT p.Team) = 1
    ),
    
    kip_changed_20 AS (
        SELECT
            AVG(9 * K / IP) AS KIP,
            AVG(
                CAST(
                    SUBSTRING_INDEX(PC_ST, '-', 1) AS DECIMAL
                )
            ) AS PC,
            AVG(
                CAST(
                    SUBSTRING_INDEX(PC_ST, '-', -1) AS DECIMAL
                )
            ) AS ST
        FROM pitchers p
            INNER JOIN games_20
             g ON p.Game = g.Game
            INNER JOIN pitcherChanged pc ON p.Pitcher_Id = pc.Pitcher_Id
        WHERE p.IP > 0
        GROUP BY
            p.Pitcher_Id
    ),
    
    kip_changed_21 AS(
        SELECT
            AVG(9 * K / IP) AS KIP,
            AVG(
                CAST(
                    SUBSTRING_INDEX(PC_ST, '-', 1) AS DECIMAL
                )
            ) AS PC,
            AVG(
                CAST(
                    SUBSTRING_INDEX(PC_ST, '-', -1) AS DECIMAL
                )
            ) AS ST
        FROM pitchers
        WHERE Game IN (
                SELECT Game
                FROM
                    games_21
            )
            AND IP > 0
            AND Pitcher_Id IN (
                SELECT Pitcher_Id
                FROM
                    pitcherChanged
            )
        GROUP BY
            Pitcher_Id
    ),
    
    kip_unchanged_20
     AS(
        SELECT
            AVG(9 * K / IP) AS KIP,
            AVG(
                CAST(
                    SUBSTRING_INDEX(PC_ST, '-', 1) AS DECIMAL
                )
            ) AS PC,
            AVG(
                CAST(
                    SUBSTRING_INDEX(PC_ST, '-', -1) AS DECIMAL
                )
            ) AS ST
        FROM pitchers
        WHERE Game IN (
                SELECT Game
                FROM
                    games_20

            )
            AND IP > 0
            AND Pitcher_Id IN (
                SELECT Pitcher_Id
                FROM
                    pitcherUnchanged
            )
        GROUP BY
            Pitcher_Id
    ),

        kip_unchanged_21 AS(
        SELECT
            AVG(9 * K / IP) AS KIP,
            AVG(
                CAST(
                    SUBSTRING_INDEX(PC_ST, '-', 1) AS DECIMAL
                )
            ) AS PC,
            AVG(
                CAST(
                    SUBSTRING_INDEX(PC_ST, '-', -1) AS DECIMAL
                )
            ) AS ST
        FROM pitchers
        WHERE Game IN (
                SELECT Game
                FROM
                    games_21
            )
            AND IP > 0
            AND Pitcher_Id IN (
                SELECT Pitcher_Id
                FROM
                    pitcherUnchanged
            )
        GROUP BY Pitcher_Id
    )
SELECT
    'Changed' AS Pitcher,
    COUNT(*) AS cnt, (
        SELECT
            ROUND(AVG(KIP), 4)
        FROM
            kip_changed_20
    ) AS '2020_avg_K/9', (
        SELECT
            ROUND(AVG(KIP), 4)
        FROM
            kip_changed_21
    ) AS '2021_avg_K/9', (
        SELECT
            CONCAT(
                CAST(ROUND(AVG(PC), 4) AS CHAR),
                '-',
                CAST(ROUND(AVG(ST), 4) AS CHAR)
            )
        FROM
            kip_changed_20
    ) AS '2020_PC-ST', (
        SELECT
            CONCAT(
                CAST(ROUND(AVG(PC), 4) AS CHAR),
                '-',
                CAST(ROUND(AVG(ST), 4) AS CHAR)
            )
        FROM
            kip_changed_21
    ) AS '2021_PC-ST'
FROM pitcherChanged
UNION
SELECT
    'Unchanged' AS Pitcher,
    COUNT(*) AS cnt, (
        SELECT
            ROUND(AVG(KIP), 4)
        FROM
            kip_unchanged_20

    ) AS '2020_avg_K/9', (
        SELECT
            ROUND(AVG(KIP), 4)
        FROM
                kip_unchanged_21
    ) AS '2021_avg_K/9', (
        SELECT
            CONCAT(
                CAST(ROUND(AVG(PC), 4) AS CHAR),
                '-',
                CAST(ROUND(AVG(ST), 4) AS CHAR)
            )
        FROM
            kip_unchanged_20

    ) AS '2020_PC-ST', (
        SELECT
            CONCAT(
                CAST(ROUND(AVG(PC), 4) AS CHAR),
                '-',
                CAST(ROUND(AVG(ST), 4) AS CHAR)
            )
        FROM
                kip_unchanged_21
    ) AS '2021_PC-ST'
FROM pitcherUnchanged;