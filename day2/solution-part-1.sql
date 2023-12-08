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

, failed_games AS (
  SELECT
    DISTINCT(game_id)
  FROM game_reveals
  WHERE colour = 'red' AND number > 12 
     OR colour = 'green' AND number > 13 
     OR colour = 'blue' AND number > 14
)

SELECT
  SUM(DISTINCT game_id)
FROM game_reveals
WHERE game_id NOT IN (
  SELECT game_id FROM failed_games
)