WITH HorizontalMatches AS (
  SELECT h.block,
    p.id AS pattern_id
  FROM hashes h
    JOIN patterns p ON h.hash LIKE '%' || p.pattern || '%'
    AND p.direction = 'h'
),
VerticalMatches AS (
  SELECT h1.block,
    p.id AS pattern_id
  FROM hashes h1
    JOIN hashes h2 ON h1.block = h2.block
    AND h1.id < h2.id
    JOIN patterns p ON SUBSTRING(
      h1.hash
      FROM (LENGTH(h1.hash) - LENGTH(p.pattern) + 1) FOR LENGTH(p.pattern)
    ) = p.pattern
    AND p.direction = 'v'
)
SELECT *
FROM HorizontalMatches
UNION
SELECT *
FROM VerticalMatches;