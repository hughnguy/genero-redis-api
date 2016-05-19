GLOBALS "../redis_globals.4gl"

FUNCTION test_connection()

  DEFINE cmd_status SMALLINT

  DISPLAY "Testing connection:"
  SLEEP 1

  { test invalid connection }
  CALL initialize_redis("127.0.0.1", 1234, "")
  LET cmd_status = redis_connect()
  IF cmd_status != 0 THEN
    DISPLAY "  Test invalid connection: PASSED"
  ELSE
    DISPLAY "  Test invalid connection: FAILED"
  END IF
  SLEEP 1

  { test valid connection }
  CALL initialize_redis("127.0.0.1", 6381, "")
  LET cmd_status = redis_connect()
  IF cmd_status = 0 THEN
    DISPLAY "  Test valid connection: PASSED"
  ELSE
    DISPLAY "  Test valid connection: FAILED"
  END IF
  SLEEP 1

  { test disconnect }
  CALL redis_disconnect()
  LET cmd_status = redis_set("test1", "hello")
  IF cmd_status = CONNECT_ERR_MSG THEN
    DISPLAY "  Test disconnection: PASSED"
  ELSE
    DISPLAY "  Test disconnection: FAILED"
  END IF
  SLEEP 1

END FUNCTION
