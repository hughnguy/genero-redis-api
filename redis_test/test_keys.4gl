FUNCTION test_keys()

  DEFINE cmd_result        STRING,
         input_array       DYNAMIC ARRAY OF STRING

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+                           Connect to Database
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

  DISPLAY "************************************"
  DISPLAY "REDIS KEYS TEST CASES"
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
  +              DEL Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing DEL command:"
  { Mock Data }
  LET cmd_result = redis_set("key1", "hello")
  LET cmd_result = redis_set("key2", "goodbye")
  LET input_array[1] = "key1"
  LET input_array[2] = "key2"
  { Test }
  LET cmd_result = redis_del(input_array)
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
  +              EXPIRE Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing EXPIRE command:"
  { Mock Data }
  LET cmd_result = redis_set("key1", "hello")
  { Test }
  LET cmd_result = redis_expire("key1", 10)
  { Output }
  DISPLAY "Output: " || cmd_result
  { Result }
  IF(cmd_result = "1") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

  {+++++++++++++++++++++++++++++++++++++++++++++
  +             PERSIST Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing PERSIST command:"
  { Mock Data }
  LET cmd_result = redis_set("key1", "hello")
  LET cmd_result = redis_expire("key1", 10)
  { Test }
  LET cmd_result = redis_persist("key1")
  { Output }
  DISPLAY "Output: " || cmd_result
  { Result }
  IF(cmd_result = "1") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

END FUNCTION

