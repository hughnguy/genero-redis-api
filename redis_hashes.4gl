{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Redis HASH commands module.
+ This module contains functions to perform HASH comamnds:
+   - HDEL key field
+   - HGET key field
+   - HSET key field value
+   - HVALS key
+
+ For more information, see: http://redis.io/commands#hash
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{ Import C libray }
IMPORT libhiredisext

{ Import global variables }
GLOBALS "redis_globals.4gl"

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Removes the specified fields from the hash stored at key
+ Where: key - key where hash field is stored
+        fields - array of fields to remove from hash
+ Returns: cmd_result - the number of fields that were removed from the hash
+
+ For more information, see: http://redis.io/commands/hdel
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_hdel(key, fields)

  DEFINE key          STRING,
         fields       DYNAMIC ARRAY OF STRING,
         buffer       base.StringBuffer,
         idx          INTEGER,
         cmd          STRING,
         cmd_result   STRING

  LET cmd = "HDEL"
  LET buffer = base.StringBuffer.create()
  CALL buffer.append(cmd || " " || key)

  FOR idx = 1 TO fields.getLength()
    CALL buffer.append(" " || fields[idx])
  END FOR

  LET cmd = buffer.toString()

  CALL exec_redis_command(cmd, NULL, NULL, NULL, NULL, NULL)
  RETURNING cmd_result

  RETURN cmd_result

END FUNCTION

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Returns the value associated with field in the hash stored at key
+ Where: key - the hash stored at key
+        field - the field in the hash
+ Returns: cmd_result - the value assocaited with field 
+
+ For more information, see: http://redis.io/commands/hget
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_hget(key, field)

  DEFINE key          STRING,
         field        STRING,
         cmd          STRING,
         cmd_result   STRING

  LET cmd = "HGET"
  CALL exec_redis_command(cmd, key, field, NULL, NULL, NULL)
  RETURNING cmd_result

  RETURN cmd_result

END FUNCTION

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Sets field in the hash stored at key to value.
+ Where: key - the hash stored at key
+        field - the field in the hash 
+        value - the value to set in field
+ Returns: cmd_result - returns: 1 - if field is a new field in the hash
+                                    and the value was set
+                                0 - if field already exists in the hash
+                                    and value was updated
+
+ For more information, see: http://redis.io/commands/hset
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_hset(key, field, value)

  DEFINE key          STRING,
         field        STRING,
         value        STRING,
         cmd          STRING,
         cmd_result   STRING

  LET cmd = "HSET"
  CALL exec_redis_command(cmd, key, field, value, NULL, NULL)
  RETURNING cmd_result

  RETURN cmd_result

END FUNCTION

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Returns all the values in the hash stored at key.
+ Where: key - the hash stored at key
+ Returns: cmd_result_array - an array of field values in the hash
+                             or empty when key does not exist
+
+ For more information, see: http://redis.io/commands/hvals
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_hvals(key)

  DEFINE key                STRING,
         cmd                STRING,
         cmd_result         STRING,
         cmd_result_array   DYNAMIC ARRAY OF STRING

  LET cmd = "HVALS"
  CALL exec_redis_command(cmd, key, NULL, NULL, NULL, NULL)
  RETURNING cmd_result
  
  { Seperate by ^ delimiter and place in array }
  CALL delimiter(cmd_result)
  RETURNING cmd_result_array

  RETURN cmd_result_array

END FUNCTION
