FUNCTION test_server()

  DEFINE  cmd_result        STRING

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+                           Connect to Database
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

  DISPLAY "************************************"
  DISPLAY "REDIS SERVER TEST CASES"
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
  +          INFO w/ param Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing INFO w/ param command:"
  { Test }
  LET cmd_result = redis_info("cluster")
  { Output }
  DISPLAY "Output: " || cmd_result
  { Result }
  IF(cmd_result IS NOT NULL) THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

  {+++++++++++++++++++++++++++++++++++++++++++++
  +          INFO w/ null Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing INFO w/ null command:"
  { Test }
  LET cmd_result = redis_info(NULL)
  { Output }
  DISPLAY "Output: " || cmd_result
  { Result }
  IF(cmd_result IS NOT NULL) THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

  {+++++++++++++++++++++++++++++++++++++++++++++
  +            FLUSHDB Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing FLUSHDB command:"
  { Test }
  LET cmd_result = redis_flushdb()
  { Output }
  DISPLAY "Output: " || cmd_result
  { Result }
  IF(cmd_result == "OK") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

END FUNCTION
