SELECT Game, CEIL(COUNT(Inning)/2) AS num_innings
FROM inning
GROUP BY Game
HAVING COUNT(Inning) = (
  SELECT COUNT(Inning) AS max_innings
  FROM inning
  GROUP BY Game
  ORDER BY max_innings DESC
  LIMIT 1
)
ORDER BY Game ASC;
