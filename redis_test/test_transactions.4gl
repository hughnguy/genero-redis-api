FUNCTION test_transactions()

  DEFINE cmd_result        STRING,
         cmd_result_array  DYNAMIC ARRAY OF STRING

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+                           Connect to Database
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

  DISPLAY "************************************"
  DISPLAY "REDIS TRANSACTIONS TEST CASES"
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
  +             DISCARD Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing DISCARD command:"
  { Mock data }
  LET cmd_result = redis_multi()
  { Test }
  LET cmd_result = redis_discard()
  { Output }
  DISPLAY "Output: " || cmd_result
  { Result }
  IF(cmd_result = "OK") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

  {+++++++++++++++++++++++++++++++++++++++++++++
  +             MULTI Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing MULTI command:"
  { Test }
  LET cmd_result = redis_multi()
  { Output }
  DISPLAY "Output: " || cmd_result
  { Result }
  IF(cmd_result = "OK") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

  {+++++++++++++++++++++++++++++++++++++++++++++
  +             EXEC Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing EXEC command:"
  { Mock data }
  LET cmd_result = redis_multi()
  LET cmd_result = redis_set("test1", "hello")
  LET cmd_result = redis_get("test1")
  { Test }
  LET cmd_result_array = redis_exec()
  { Output }
  DISPLAY "Output: " || cmd_result_array[1]
  DISPLAY "Output: " || cmd_result_array[2]
  DISPLAY "Output: " || cmd_result_array[3]
  { Result }
  IF(cmd_result_array[1] = "OK" AND
     cmd_result_array[2] = "OK" AND
     cmd_result_array[3] = "hello") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

END FUNCTION

