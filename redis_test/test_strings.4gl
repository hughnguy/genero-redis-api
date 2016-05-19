FUNCTION test_strings()

  DEFINE cmd_result        STRING,
         keys              DYNAMIC ARRAY OF STRING,
         cmd_result_array  DYNAMIC ARRAY OF STRING

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+                           Connect to Database
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
  
  DISPLAY "************************************"
  DISPLAY "REDIS STRINGS TEST CASES"
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
  +              SET Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing SET command:"
  { Test }
  LET cmd_result = redis_set("test1", "hello")
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
  +              GET Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing GET command:"
  { Mock data }
  LET cmd_result = redis_set("test1", "hello")
  { Test }
  LET cmd_result = redis_get("test1")
  { Output }
  DISPLAY "Output: " || cmd_result
  { Result }
  IF(cmd_result == "hello") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"
 
  {+++++++++++++++++++++++++++++++++++++++++++++
  +              MGET Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing MGET command:"
  { Mock data }
  LET cmd_result = redis_set("test1", "hello")
  LET cmd_result = redis_set("test2", "goodbye")
  LET keys[1] = "test1"
  LET keys[2] = "test2"
  { Test }
  LET cmd_result_array = redis_mget(keys)
  { Output }
  DISPLAY "Output: " || cmd_result_array[1]
  DISPLAY "Output: " || cmd_result_array[2]
  { Result }
  IF(cmd_result_array[1] == "hello" AND cmd_result_array[2] == "goodbye") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

END FUNCTION
