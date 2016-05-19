{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Redis GENERIC commands module.
+ This module contains functions to perform GENERIC comamnds:
+   - DEL key
+   - EXPIRE key seconds
+   - PERSIST key
+
+ For more information, see: http://redis.io/commands#generic
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{ Import C libray }
IMPORT libhiredisext

{ Import global variables }
GLOBALS "redis_globals.4gl"

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Remove the specified key
+ Where: keys - an array of keys to remove
+ Returns: cmd_result - the number of keys that were removed
+
+ For more information, see: http://redis.io/commands/del
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_del(keys)

  DEFINE keys         DYNAMIC ARRAY OF STRING,
         buffer       base.StringBuffer,
         idx          INTEGER,
         cmd          STRING,
         cmd_result   STRING

  LET cmd = "DEL"
  LET buffer = base.StringBuffer.create()
  CALL buffer.append(cmd)

  FOR idx = 1 TO keys.getLength()
    CALL buffer.append(" " || keys[idx])
  END FOR
  
  LET cmd = buffer.toString()

  CALL exec_redis_command(cmd, NULL, NULL, NULL, NULL, NULL)
  RETURNING cmd_result

  RETURN cmd_result

END FUNCTION

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Set a timeout on key. After the timeout has expired, the key
+ will automatically be deleted
+ Where: key - specified key to set timeout on
         seconds - timeout in seconds
+ Returns: reply - returns: 1 if the timeout was set
+                           0 if the key does not exist or timeout could
+                             not be set
+
+ For more information, see: http://redis.io/commands/expire
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_expire(key, seconds)

  DEFINE key          STRING,
         seconds      INT,
         cmd          STRING,
         cmd_result   STRING

  LET cmd = "EXPIRE"
  CALL exec_redis_command(cmd, key, seconds, NULL, NULL, NULL)
  RETURNING cmd_result

  RETURN cmd_result

END FUNCTION

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Remove the existing timeout on key
+ Where: key - specified key to remove timeout on
+ Returns: reply - returns: 1 if the timeout was removed
                            0 if the key does not exists or has an
                              associated timeout
+
+ For more information, see: http://redis.io/commands/persist
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_persist(key)

  DEFINE key          STRING,
         cmd          STRING,
         cmd_result   STRING

  LET cmd = "PERSIST"
  CALL exec_redis_command(cmd, key, NULL, NULL, NULL, NULL)
  RETURNING cmd_result

  RETURN cmd_result

END FUNCTION

