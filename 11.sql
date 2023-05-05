WITH home_team_wins AS (
  SELECT COUNT(*) AS total_home_wins
  FROM games
  WHERE home_score > away_score
),
total_games AS (
  SELECT COUNT(*) AS total_games_count
  FROM games
),
home_win_percentage AS (
  SELECT (total_home_wins / total_games_count) * 100 AS home_win_pct
  FROM home_team_wins, total_games
),
team_score AS (
  SELECT 
    Team, 
    AVG(((9 * K) / IP) + H + R + ER + BB + HR) AS team_avg_score
  FROM pitchers
  GROUP BY Team
),
higher_score_team_wins AS (
  SELECT COUNT(*) AS total_higher_score_wins
  FROM games g
  JOIN team_score ts_home ON g.home = ts_home.Team
  JOIN team_score ts_away ON g.away = ts_away.Team
  WHERE (g.home_score > g.away_score AND ts_home.team_avg_score > ts_away.team_avg_score)
    OR (g.away_score > g.home_score AND ts_away.team_avg_score > ts_home.team_avg_score)
),
higher_score_win_percentage AS (
  SELECT (total_higher_score_wins / total_games_count) * 100 AS higher_score_win_pct
  FROM higher_score_team_wins, total_games
)
SELECT 
  home_win_pct AS home_team_win_percentage,
  higher_score_win_pct AS higher_score_team_win_percentage
FROM home_win_percentage, higher_score_win_percentage;
