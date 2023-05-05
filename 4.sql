SELECT pl.Name,
       ROUND(AVG(h.num_P / (h.AB + h.BB + h.K)), 4) as Avg_P_PA,
   
       AVG(h.AB) as Avg_AB,
       AVG(h.BB) as Avg_BB,
       AVG(h.K) as Avg_K,
           SUM(h.AB + h.BB + h.K) as tol_PA
FROM hitters h
JOIN players pl ON h.Hitter_Id = pl.Id
WHERE h.AB + h.BB + h.K > 0
GROUP BY h.Hitter_Id, pl.Name
HAVING SUM(h.AB + h.BB + h.K) >= 20
ORDER BY Avg_P_PA DESC
LIMIT 3;
