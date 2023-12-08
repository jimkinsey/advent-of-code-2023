WITH input AS (
  SELECT * FROM `datasn-user-jim.advent_of_code.day_2_puzzle_input`
)

, raw_reveals_with_id AS (
    SELECT 
      PARSE_NUMERIC(REGEXP_EXTRACT(game, '^Game\\s(\\d+)\\:')) AS game_id
      , SPLIT(REGEXP_EXTRACT(game, '^Game\\s\\d+\\:(.*)$'), ';') AS raw_reveals
    FROM input
)

, colour_counts_with_id AS (
  SELECT
    game_id
    , SPLIT(raw_reveal, ',') AS colour_counts
  FROM raw_reveals_with_id
  , UNNEST(raw_reveals) AS raw_reveal
)

, game_reveals AS (
  SELECT
    game_id
    , PARSE_NUMERIC(REGEXP_EXTRACT(colour_count, '(\\d+) (?:red|green|blue)')) AS number
    , REGEXP_EXTRACT(colour_count, '(?:\\d+) (red|green|blue)') AS colour
  FROM colour_counts_with_id
  , UNNEST(colour_counts) AS colour_count
)

, fewest_cube_counts AS (
  SELECT
    game_id
    , colour
    , MAX(number) AS number
  FROM game_reveals
  GROUP BY 1, 2
)

, powers AS (
  SELECT 
    game_id
    , ROUND(EXP(SUM(LN(number)))) AS power
  FROM fewest_cube_counts
  GROUP BY 1
)

SELECT 
  SUM(power) AS result
FROM powers