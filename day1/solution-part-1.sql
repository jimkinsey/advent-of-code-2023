WITH extracted_digits AS (
  SELECT 
    REGEXP_EXTRACT_ALL(calibration_value, '(\\d)') AS digits
  FROM `datasn-user-jim.advent_of_code.day_1_puzzle_input`
)

, numbers AS (
  SELECT
    PARSE_NUMERIC(digits[OFFSET(0)]||ARRAY_REVERSE(digits)[OFFSET(0)]) AS number
  FROM extracted_digits
)

SELECT SUM(number) FROM numbers