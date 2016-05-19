GLOBALS "../redis_globals.4gl"

FUNCTION test_geo()
  
  DEFINE cmd_result        STRING,
         cmd_result_array  DYNAMIC ARRAY OF STRING,
         input_array       DYNAMIC ARRAY OF STRING,
         coordinate_array  DYNAMIC ARRAY OF redis_coordinate

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+                           Connect to Database
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
 
  DISPLAY "************************************"
  DISPLAY "REDIS GEO TEST CASES"
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
  +              GEOADD Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing GEOADD command:"
  { Test }
  LET cmd_result = redis_geoadd("key1", "13.361389", "15.08473", "Ottawa")
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
  +              GEOHASH Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing GEOHASH command:"
  { Mock data }
  LET cmd_result = redis_geoadd("key1", "13.361389", "15.08473", "Ottawa")
  LET cmd_result = redis_geoadd("key1", "20.323243", "28.93493", "Toronto")
  LET input_array[1] = "Ottawa"
  LET input_array[2] = "Toronto"
  { Test }
  LET cmd_result_array = redis_geohash("key1", input_array)
  { Output }
  DISPLAY "Output: " || cmd_result_array[1]
  DISPLAY "Output: " || cmd_result_array[2]
  { Result }
  IF(cmd_result_array[1] = "s69tb416yv0" AND
     cmd_result_array[2] = "smnkw7qyjy0") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

  {+++++++++++++++++++++++++++++++++++++++++++++
  +              GEOPOS Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing GEOPOS command:"
  { Mock data }
  LET cmd_result = redis_geoadd("key1", "13.361389", "15.08473", "Ottawa")
  LET cmd_result = redis_geoadd("key1", "20.323243", "28.93493", "Toronto")
  LET input_array[1] = "Ottawa"
  LET input_array[2] = "Toronto"
  { Test }
  LET coordinate_array = redis_geopos("key1", input_array)
  { Output }
  DISPLAY "Output: " || coordinate_array[1].longitude
  DISPLAY "Output: " || coordinate_array[1].latitude
  DISPLAY "Output: " || coordinate_array[2].longitude
  DISPLAY "Output: " || coordinate_array[2].latitude
  { Result }
  IF(coordinate_array[1].longitude = "13.361389338970184" AND
     coordinate_array[1].latitude = "15.084730150222605" AND
     coordinate_array[2].longitude = "20.323245227336884" AND
     coordinate_array[2].latitude = "28.934930696592062") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

  {+++++++++++++++++++++++++++++++++++++++++++++
  +              GEODIST Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing GEODIST command:"
  { Mock data }
  LET cmd_result = redis_geoadd("key1", "13.361389", "15.08473", "Ottawa")
  LET cmd_result = redis_geoadd("key1", "20.323243", "28.93493", "Toronto")
  { Test }
  LET cmd_result = redis_geodist("key1", "Ottawa", "Toronto", "m")
  { Output }
  DISPLAY "Output: " || cmd_result
  { Result }
  IF(cmd_result = "1698444.0947662976") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

  {+++++++++++++++++++++++++++++++++++++++++++++
  +            GEORADIUS Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing GEORADIUS command:"
  { Mock data }
  LET cmd_result = redis_geoadd("key1", "13.361389", "15.08473", "Ottawa")
  LET cmd_result = redis_geoadd("key1", "20.323243", "28.93493", "Toronto")
  { Test }
  LET cmd_result_array = redis_georadius("key1", "12", "15", "100000000000000", "m")
  { Output }
  DISPLAY "Output: " || cmd_result_array[1]
  DISPLAY "Output: " || cmd_result_array[2]
  { Result }
  IF(cmd_result_array[1] = "Ottawa" AND
     cmd_result_array[2] = "Toronto") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

  {+++++++++++++++++++++++++++++++++++++++++++++
  +        GEORADIUSBYMEMBER Testcase
  +++++++++++++++++++++++++++++++++++++++++++++}
  DISPLAY "Testing GEORADIUSBYMEMBER command:"
  { Mock data }
  LET cmd_result = redis_geoadd("key1", "13.361389", "15.08473", "Ottawa")
  LET cmd_result = redis_geoadd("key1", "20.323243", "28.93493", "Toronto")
  { Test }
  LET cmd_result_array = redis_georadius_bymember("key1", "Ottawa", "100000000000000", "m")
  { Output }
  DISPLAY "Output: " || cmd_result_array[1]
  DISPLAY "Output: " || cmd_result_array[2]
  { Result }
  IF(cmd_result_array[1] = "Ottawa" AND
     cmd_result_array[2] = "Toronto") THEN
    DISPLAY "Result: PASSED"
  ELSE
    DISPLAY "Result: FAILED"
  END IF
  { Delete data }
  LET cmd_result = redis_flushdb()
  DISPLAY "------------------------------------"

END FUNCTION
