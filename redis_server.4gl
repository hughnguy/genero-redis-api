{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Redis SERVER commands module.
+ This module contains functions to perform SERVER comamnds:
+   - INFO [section]
+   - FLUSHDB
+
+ For more information, see: http://redis.io/commands#server
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{ Import C Library }
IMPORT libhiredisext

{ Import global variables }
GLOBALS "redis_globals.4gl"

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Returns information and statistics about the server
+ Where: section - a specific section to select, set to NULL to display
+ all information about the server
+ Returns: cmd_result - information in easy to read format
+
+ For more information, see: http://redis.io/commands/info
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_info(section)

  DEFINE section      STRING, 
         cmd          STRING,
         cmd_result   STRING

  LET cmd = "INFO"
  { Check for optional parameter } 
  IF section IS NULL THEN
    CALL exec_redis_command(cmd, NULL, NULL, NULL, NULL, NULL)
    RETURNING cmd_result
  ELSE
    CALL exec_redis_command(cmd, section, NULL, NULL, NULL, NULL)
    RETURNING cmd_result
  END IF

  RETURN cmd_result

END FUNCTION


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Delete all keys of the currently selected DB
+ Returns: cmd_result - returns: OK if executed correctly
+                                NULL if executed incorrectly
+
+ For more information, see: http://redis.io/commands/flushdb
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_flushdb()

  DEFINE cmd          STRING,
         cmd_result   STRING

  LET cmd = "FLUSHDB"
  CALL exec_redis_command(cmd, NULL, NULL, NULL, NULL, NULL)
  RETURNING cmd_result

  RETURN cmd_result

END FUNCTION

