{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ This module contains asynchronous function calls to handle redis channel
+ subscriptions
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

IMPORT libhiredisext

GLOBALS "redis_globals.4gl"

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Connect to redis server at the specified address/port.
+ Where: conn_address - server address (127.0.0.1)
+        conn_port    - redis server port (6379)
+        conn_passwd  - authentication password (optional)
+ Returns: conn_status - connection status (0 = success)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_async_connect(conn_address, conn_port, conn_passwd)
 
  DEFINE conn_address STRING,
         conn_port    SMALLINT,
         conn_passwd  STRING,
         cmd_status   SMALLINT,
         cmd_result   STRING

  CALL redisAsyncConnectExt(conn_address, LENGTH(conn_address), conn_port,
                            conn_passwd, LENGTH(conn_passwd))
  RETURNING cmd_status, cmd_result
  IF cmd_status = REDIS_OK THEN
    CALL ERRORLOG(SFMT("Async Redis connection established at %1:%2.", conn_address, conn_port))
  ELSE
    CALL ERRORLOG(SFMT("ERROR: Unable to connect to Redis at %1:%2 = %3", 
                       conn_address, conn_port, cmd_result))
  END IF

  RETURN cmd_status

END FUNCTION


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Disconnect from the current async Redis connection
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_async_disconnect()

  DEFINE cmd_status SMALLINT,
         cmd_result STRING

  CALL redisAsyncDisconnectExt() RETURNING cmd_status, cmd_result
  IF cmd_status = REDIS_OK THEN
    CALL ERRORLOG("Disconnected from Async Redis connection.")
  ELSE
    CALL ERRORLOG(SFMT("Async disconnect error: %1", cmd_result))
  END IF

  RETURN cmd_status

END FUNCTION
