SELECT DISTINCT _Type AS Type
FROM pitches
WHERE _Type NOT IN (
        SELECT DISTINCT _Type
        FROM pitches
        WHERE MPH > 95
    )
ORDER BY Type;