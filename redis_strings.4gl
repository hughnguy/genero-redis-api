{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Redis STRING commands module.
+ This module contains functions to perform STRING comamnds:
+   - GET key
+   - SET key value
+   - MGET key [key ...]
+
+ For more information, see: http://redis.io/commands#string
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{ Import C library }
IMPORT libhiredisext

{ Import global variables }
GLOBALS "redis_globals.4gl"

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Get value of key
+ Where: key - key to get value from
+ Returns: cmd_result - the value of key or nil when key does not exist
+
+ For more information, see: http://redis.io/commands/get
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_get(key)

  DEFINE key          STRING,
         cmd          STRING,
         cmd_result   STRING

  LET cmd = "GET"
  CALL exec_redis_command(cmd, key, NULL, NULL, NULL, NULL)
  RETURNING cmd_result
  
  RETURN cmd_result

END FUNCTION

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Set the value of key
+ Where: key - key to set value of
+        value - the value to set in key
+ Returns: cmd_result - returns: OK if executed correctly
+                                NULL if executed incorrectly
+
+ For more information, see: http://redis.io/commands/set
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_set(key, value)

  DEFINE key          STRING,
         value,       STRING,
         cmd          STRING,
         cmd_result   STRING
  
  LET cmd = "SET"
  CALL exec_redis_command(cmd, key, value, NULL, NULL, NULL)
  RETURNING cmd_result
  
  RETURN cmd_result
  
END FUNCTION

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Returns value of the specified key
+ Where: keys - an array of keys
+ Returns: cmd_result_array - an array of values at the specified keys
+
+ For more information, see: http://redis.io/commands/mget
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_mget(keys)

  DEFINE keys              DYNAMIC ARRAY OF STRING,
         buffer            base.StringBuffer,
         idx               INTEGER,
         cmd               STRING,
         cmd_result        STRING,
         cmd_result_array  DYNAMIC ARRAY OF STRING

  LET cmd = "MGET"
  LET buffer = base.StringBuffer.create()
  CALL buffer.append(cmd)

  FOR idx = 1 TO keys.getLength()
    CALL buffer.append(" " || keys[idx]) 
  END FOR

  LET cmd = buffer.toString()

  CALL exec_redis_command(cmd, NULL, NULL, NULL, NULL, NULL)
  RETURNING cmd_result

  { Seperate by ^ delimiter and place in array }
  CALL delimiter(cmd_result)
  RETURNING cmd_result_array 

  RETURN cmd_result_array

END FUNCTION

