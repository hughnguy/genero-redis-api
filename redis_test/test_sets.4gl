FUNCTION test_sets()

  DEFINE input_array       DYNAMIC ARRAY OF STRING,
         cmd_result        STRING,
         cmd_result_array  DYNAMIC ARRAY OF STRING

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+                           Connect to Database
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

  DISPLAY "************************************"
  DISPLAY "REDIS SETS TEST CASES"
  DISPLAY "************************************"
  DISPLAY "Initializing redis..."

  { Initialize Redis credentials }
  CALL initialize_redis("127.0.0.1", 6381, "vtm001")
  { Select test database }
  LET cmd_result = redis_select(1)
  DISPLAY "Selecting database 1 for testing: " || cmd_result
  LET cmd_result = redis_flushdb()
  DISPLAY "Flushing database for new test scenario: " || cmd_result
  DISPLAY "------------------------------------"
  
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+                                Testcases
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

  {+++++++++++++++++++++++++++++++++++++++++++++
  +              SADD Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing SADD command:"
  { Mock data }
  LET input_array[1] = "hello"
  LET input_array[2] = "goodbye"
  { Test }
  LET cmd_result = redis_sadd("newtest", input_array)
  { Output }
  DISPLAY "Output: " || cmd_result
  { Result }
  IF(cmd_result = "2") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

  {+++++++++++++++++++++++++++++++++++++++++++++
  +            SMEMBERS Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing SMEMBERS command:"
  { Mock data }
  LET input_array[1] = "hello"
  LET input_array[2] = "goodbye"
  LET cmd_result = redis_sadd("newtest", input_array)
  { Test }
  LET cmd_result_array = redis_smembers("newtest")
  { Output }
  DISPLAY "Output: " || cmd_result_array[1]
  DISPLAY "Output: " || cmd_result_array[2]
  { Result }
  IF(cmd_result_array[1] == "goodbye" AND cmd_result_array[2] == "hello") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

  {+++++++++++++++++++++++++++++++++++++++++++++
  +            SREM Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing SREM command:"
  { Mock data }
  LET input_array[1] = "hello"
  LET input_array[2] = "goodbye"
  LET cmd_result = redis_sadd("newtest", input_array)
  { Test }
  LET cmd_result = redis_srem("newtest", input_array)
  { Output }
  DISPLAY "Output: " || cmd_result
  { Result }
  IF(cmd_result == "2") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

END FUNCTION
