{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Redis Common module.
+ This module contains functions that are shared between all redis modules.
+
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{ Import C library }
IMPORT libhiredisext

{ Import global variables }
GLOBALS "redis_globals.4gl"

{++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Description: This function calls the libredisapi.so function to execute the
+              redis command. If logging is enabled, it will log the command to
+              the debug file (redis_test.log).  An error is written to the
+              application log if the command did not execute successfully.
+              In a case where there is a problem executing a command, we will
+              restart the redis connection and attempt to execute the command
+              another time before giving up.
+ Params:
+   command        - the redis command to execute
+   param1         - the first parameter
+   param2         - the second parameter
+   param3         - the third paramter
+   param4         - the fourth parameter
+   param5         - the fifth parameter
+   command_status - 0 if successful, -1 if connection err, -2 if command err
+ Returns:
+   command_result - the result string of the executed command (if applicable).
+                    If the command did not execute successfully, this contains
+                    the redis error message.
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION exec_redis_command(command, param1, param2, param3, param4, param5)
  
  DEFINE command      STRING,
         param1       STRING,
         param2       STRING,
         param3       STRING,
         param4       STRING,
         param5       STRING,
	 cmd_status   SMALLINT,
	 cmd_result   STRING
  
  { Connect to redis }
  IF NOT redis_connected THEN
    CALL redis_connect() RETURNING cmd_status
  END IF
  
  { Execute command }
  IF redis_connected THEN
    CALL redisCommandExt(command, LENGTH(command), param1, LENGTH(param1),
			 param2, LENGTH(param2), param3, LENGTH(param3),
			 param4, LENGTH(param4), param5, LENGTH(param5))
    RETURNING cmd_status, cmd_result
    
    { If connection error }
    IF cmd_status = REDIS_ERROR THEN
      CALL ERRORLOG(SFMT("ERROR: A connection error occured." ||
                         "Unable to perform - %1 %2 %3 %4 %5 %6",
			 command, param1, param2, param3, param4, param5))
      CALL ERRORLOG("Attempting to reconnect and try again...")
      
      { Reconnect and try again }
      CALL redis_disconnect()
      CALL redis_connect() RETURNING cmd_status

      IF cmd_status = REDIS_OK AND redis_connected THEN
        CALL redisCommandExt(command, LENGTH(command), param1, LENGTH(param1),
			     param2, LENGTH(param2), param3, LENGTH(param3),
			     param4, LENGTH(param4), param5, LENGTH(param5))
        RETURNING cmd_status, cmd_result
        
        IF cmd_status = REDIS_ERROR THEN
	  CALL ERRORLOG(SFMT("ERROR: Still unable to perform: %1 %2 %3 %4 %5 %6",
	                     command, param1, param2, param3, param4, param5))
	  LET cmd_result = CONNECT_ERR_MSG
	END IF
      ELSE
        LET cmd_result = CONNECT_ERR_MSG
      END IF
    END IF
  ELSE
    LET cmd_result = CONNECT_ERR_MSG
  END IF

  RETURN cmd_result

END FUNCTION


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Delimiter to seperate command result that is an array of data
+ and returned as a string delimited by '^' character
+
+ Where: entry - command result with '^' as delimiter
+ Returns: delimiter_array - an array of delimited values
+
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION delimiter(entry)

  DEFINE entry              STRING,
         delimiter_array    DYNAMIC ARRAY OF STRING,
         tok                base.StringTokenizer,
         count              INT

  LET tok = base.StringTokenizer.create(entry, "^")
  LET count = 1

  WHILE tok.hasMoreTokens()
    LET delimiter_array[count] = tok.nextToken()
    LET count = count + 1
  END WHILE

  RETURN delimiter_array

END FUNCTION


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Delimiter for a 2D array to seperate every first and second string
+ delimited by '^' into an array of 2 element records (longitude, latitude).
+ Used with the redis geopos function.
+
+ Where: entry - command result with '^' as delimiter
+ Returns: delimiter_array - an array of delimited values
+
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION geoposDelimiter(entry)

  DEFINE entry              STRING,
         delimiter_array    DYNAMIC ARRAY OF redis_coordinate,
         tok                base.StringTokenizer,
         count              INT

  LET tok = base.StringTokenizer.create(entry, "^")
  LET count = 1

  WHILE tok.hasMoreTokens()
    LET delimiter_array[count].longitude = tok.nextToken()
    LET delimiter_array[count].latitude = tok.nextToken()
    LET count = count + 1
  END WHILE

  RETURN delimiter_array

END FUNCTION

