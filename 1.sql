SELECT count(*) AS cnt
FROM games
WHERE ABS(home_score-away_score) > 9