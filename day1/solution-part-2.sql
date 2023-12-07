WITH input AS (
  SELECT * FROM `datasn-user-jim.advent_of_code.day_2_puzzle_input`
)

, num_mapping AS (
  SELECT
    word AS from_num
    , CAST(o AS STRING) AS to_num
  FROM UNNEST(['zero','one','two','three', 'four', 'five', 'six', 'seven', 'eight', 'nine']) AS word WITH OFFSET o
  UNION ALL
  SELECT
    number AS from_num
    , CAST(o AS STRING) AS to_num
  FROM UNNEST(['0','1','2','3','4','5','6','7','8','9']) AS number WITH OFFSET o
  ORDER BY 2
)

, extracted_numbers AS (
  SELECT 
    REGEXP_EXTRACT(LOWER(calibration_value), '(\\d|one|two|three|four|five|six|seven|eight|nine)') AS first_num
    , REVERSE(REGEXP_EXTRACT(LOWER(REVERSE(calibration_value)), '(\\d|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin)')) AS last_num
  FROM input 
)

, to_sum AS (
  SELECT
    PARSE_NUMERIC(first_n.to_num||last_n.to_num) AS calibration_value
  FROM extracted_numbers en
  LEFT JOIN num_mapping first_n ON en.first_num = first_n.from_num
  LEFT JOIN num_mapping last_n ON en.last_num = last_n.from_num
)

SELECT sum(calibration_value) FROM to_sum
