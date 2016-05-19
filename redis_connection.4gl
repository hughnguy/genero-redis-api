{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Redis CONNECTION commands module.
+ This module contains functions to connect/disconnect to the redis server,
+ and a subset CONNECTION commands:
+   - AUTH password
+   - SELECT index
+
+ For more information, see: http://redis.io/commands#connection
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

IMPORT libhiredisext

GLOBALS "redis_globals.4gl"

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Initializes the host, port, and password for redis connection
+
+ Where: host - the host to set to globally defined variable
+        port - the port to set to globally defined variable
+        password - the password to set to globally defined variable
+
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION initialize_redis(host, port, password)

  DEFINE host      STRING,
         port      SMALLINT,
         password  STRING

  { Set variables }
  LET redis_host = host
  LET redis_port = port
  LET redis_password = password

END FUNCTION


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Connect to redis server at the specified address/port.
+ Where: conn_address - server address (127.0.0.1)
+        conn_port    - redis server port (6379)
+        conn_passwd  - authentication password (optional)
+ Returns: conn_status - connection status (0 = success)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_connect()
 
  DEFINE cmd_status   SMALLINT,
         cmd_result   STRING

  CALL redisConnectExt(redis_host, LENGTH(redis_host), redis_port)
  RETURNING cmd_status, cmd_result

  IF cmd_status = REDIS_OK THEN
    CALL ERRORLOG(SFMT("Redis connection established at %1:%2.", redis_host, redis_port))
    IF LENGTH(redis_password) > 0 THEN
      CALL redis_auth(redis_password) RETURNING cmd_result
      LET redis_connected = TRUE
    END IF
  ELSE
    CALL ERRORLOG(SFMT("ERROR: Unable to connect to Redis at %1:%2.", redis_host, redis_port))
    LET redis_connected = FALSE
  END IF

  RETURN cmd_status

END FUNCTION


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Disconnect the current redis connection
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_disconnect()
  
  CALL redisDisconnectExt()
  LET redis_connected = FALSE
  CALL ERRORLOG("Redis has disconnected!")

END FUNCTION


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Request for authentication in a password-protected Redis server
+ Where: password - authentication password (refer to redis.conf) 
+
+ For more information, see: http://redis.io/commands/auth
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_auth(password)

  DEFINE password   STRING,
         cmd        STRING,
	 cmd_status SMALLINT,
         cmd_result STRING

  LET cmd = "AUTH"

  { Cannot use exec_redis_command() since that will cause endless loop }
  CALL redisCommandExt(cmd, LENGTH(cmd), password, LENGTH(password),
                       NULL, 0, NULL, 0, NULL, 0, NULL, 0)
  RETURNING cmd_status, cmd_result

  IF cmd_status = REDIS_ERROR THEN
    CALL ERRORLOG("Unable to authenticate.")
  END IF

  RETURN cmd_result

END FUNCTION


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Change the selected database for the current connection.
+ Where: db_num - database number (zero-based numeric index)
+
+ For more infomation, see: http://redis.io/commands/select
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_select(db_num)

  DEFINE db_num       SMALLINT,
         cmd          STRING,
	 cmd_result   STRING
  
  LET cmd = "SELECT"
  CALL exec_redis_command(cmd, db_num, NULL, NULL, NULL, NULL)
  RETURNING cmd_result
  
  RETURN cmd_result

END FUNCTION
