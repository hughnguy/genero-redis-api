{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Redis SET commands module.
+ This module contains functions to perform SET comamnds:
+   - SADD key member
+   - SMEMBERS key
+   - SREM key member
+
+ For more information, see: http://redis.io/commands#set
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

GLOBALS "redis_globals.4gl"

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Add the specified member to the set stored at key.
+ Where: key - the key where the set is stored
+        members - an array of members to add to set
+ Returns: cmd_result - the number of elements that were added to the set
+
+ For more information, see: http://redis.io/commands/sadd
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_sadd(key, members)

  DEFINE key          STRING,
         members      DYNAMIC ARRAY OF STRING,
         buffer       base.StringBuffer,
         idx          INTEGER,
         cmd          STRING,
         cmd_result   STRING

  LET cmd = "SADD"
  LET buffer = base.StringBuffer.create()
  CALL buffer.append(cmd || " " || key)

  FOR idx = 1 TO members.getLength()
    CALL buffer.append(" " || members[idx])
  END FOR

  LET cmd = buffer.toString()

  CALL exec_redis_command(cmd, NULL, NULL, NULL, NULL, NULL)
  RETURNING cmd_result

  RETURN cmd_result
        
END FUNCTION

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Returns all the members of the set value stored at key.
+ Where: key - the key where the set is stored
+ Returns: cmd_result_array - array containing all elements of the set
+
+ For more information, see: http://redis.io/commands/smembers
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_smembers(key)

  DEFINE key               STRING,
         cmd               STRING,
         cmd_result        STRING,
         cmd_result_array  DYNAMIC ARRAY OF STRING

  LET cmd = "SMEMBERS"
  CALL exec_redis_command(cmd, key, NULL, NULL, NULL, NULL)
  RETURNING cmd_result

  { Seperate by ^ delimiter and place in array }
  CALL delimiter(cmd_result)
  RETURNING cmd_result_array

  RETURN cmd_result_array 

END FUNCTION


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Remove the specified member from the set stored at key.
+ Where: key - the key where the set is stored
+        members - array of members to remove from the set
+ Returns: cmd_result - the number of elements that were removed from the set
+
+ For more information, see: http://redis.io/commands/srem
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_srem(key, members)

  DEFINE key          STRING,
         members      DYNAMIC ARRAY OF STRING,
         buffer       base.StringBuffer,
         arguments    STRING,
         idx          INTEGER,
         cmd          STRING,
         cmd_result   STRING

  LET cmd = "SREM"
  LET buffer = base.StringBuffer.create()
  CALL buffer.append(cmd || " " || key)

  FOR idx = 1 TO members.getLength()
    CALL buffer.append(" " || members[idx])
  END FOR

  LET cmd = buffer.toString()

  CALL exec_redis_command(cmd, NULL, NULL, NULL, NULL, NULL)
  RETURNING cmd_result

  RETURN cmd_result

END FUNCTION
