MAIN

  CALL STARTLOG("async_test.log")

  CALL test_connection()
  CALL test_disconnection()

END MAIN

FUNCTION test_connection()

  DEFINE cmd_status SMALLINT

  DISPLAY "Testing Async connection:"
  SLEEP 1

  { test invalid port }
  LET cmd_status = redis_async_connect("127.0.0.1", 1234, "vtm001")
  IF cmd_status != 0 THEN
    DISPLAY "  Test invalid port: PASSED"
  ELSE
    DISPLAY "  Test invalid port: FAILED"
  END IF
  SLEEP 1

  { test invalid host }
--LET cmd_status = redis_async_connect("1.2.3.4", 6381, "vtm001")
--IF cmd_status != 0 THEN
--  DISPLAY "  Test invalid host: PASSED"
--ELSE
--  DISPLAY "  Test invalid host: FAILED"
--END IF
--SLEEP 1

  { test invalid password }
  LET cmd_status = redis_async_connect("127.0.0.1", 6381, "secret")
  IF cmd_status != 0 THEN
    DISPLAY "  Test invalid password: PASSED"
  ELSE
    DISPLAY "  Test invalid password: FAILED"
  END IF
  SLEEP 1

  { test valid connection }
  LET cmd_status = redis_async_connect("127.0.0.1", 6381, "vtm001")
  IF cmd_status = 0 THEN
    DISPLAY "  Test valid connection: PASSED"
  ELSE
    DISPLAY "  Test valid connection: FAILED"
  END IF
  SLEEP 1


END FUNCTION


FUNCTION test_disconnection()

  DEFINE cmd_status SMALLINT

  DISPLAY "Testing Async disconnection:"
  SLEEP 1

  { test disconnection }
  LET cmd_status = redis_async_disconnect()
  IF cmd_status = 0 THEN
    DISPLAY "  Test valid connection: PASSED"
  ELSE
    DISPLAY "  Test valid connection: FAILED"
  END IF
  SLEEP 1

END FUNCTION
