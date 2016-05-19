FUNCTION test_hashes()

  DEFINE cmd_result        STRING,
         input_array       DYNAMIC ARRAY OF STRING,
         cmd_result_array  DYNAMIC ARRAY OF STRING

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+                           Connect to Database
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

  DISPLAY "************************************"
  DISPLAY "REDIS HASHES TEST CASES"
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
  +              HDEL Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing HDEL command:"
  { Mock data }
  LET cmd_result = redis_hset("myhash", "field1", "hello")
  LET cmd_result = redis_hset("myhash", "field2", "goodbye")
  LET input_array[1] = "field1"
  LET input_array[2] = "field2"
  { Test }
  LET cmd_result = redis_hdel("myhash", input_array)
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
  
  {+++++++++++++++++++++++++++++++++++++++++++++
  +              HGET Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing HGET command:"
  { Mock data }
  LET cmd_result = redis_hset("myhash", "field1", "hello")
  { Test }
  LET cmd_result = redis_hget("myhash", "field1")
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
  +              HSET Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing HSET command:"
  { Test }
  LET cmd_result = redis_hset("myhash", "field1", "hello")
  { Output }
  DISPLAY "Output: " || cmd_result
  { Result }
  IF(cmd_result == "1") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

  {+++++++++++++++++++++++++++++++++++++++++++++
  +              HVALS Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing HVALS command:"
  { Mock data }
  LET cmd_result = redis_hset("myhash", "field1", "hello")
  LET cmd_result = redis_hset("myhash", "field2", "goodbyeeeeeE")
  LET cmd_result = redis_hset("myhash", "field3", "foo")
  { Test }
  LET cmd_result_array = redis_hvals("myhash")
  { Output }
  DISPLAY "Output: " || cmd_result_array[1]
  DISPLAY "Output: " || cmd_result_array[2]
  DISPLAY "Output: " || cmd_result_array[3]
  { Result }
  IF(cmd_result_array[1] == "hello" AND 
    cmd_result_array[2] == "goodbyeeeeeE" AND
    cmd_result_array[3] == "foo") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

END FUNCTION
