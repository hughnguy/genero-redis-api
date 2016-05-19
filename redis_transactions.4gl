{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Redis TRANSACTIONS commands module.
+ This module contains functions to perform TRANSACTIONS comamnds:
+   - DISCARD
+   - MULTI
+   - EXEC 
+
+ For more information, see: http://redis.io/commands#transactions
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{ Import C libray }
IMPORT libhiredisext

{ Import global variables }
GLOBALS "redis_globals.4gl"

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Flushes all previously queued commands in a transaction and restores 
+ the connection state to normal.
+ Returns: cmd_result - always returns OK
+
+ For more information, see: http://redis.io/commands/discard
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_discard()

  DEFINE cmd          STRING,
         cmd_result   STRING

  LET cmd = "DISCARD"
  CALL exec_redis_command(cmd, NULL, NULL, NULL, NULL, NULL)
  RETURNING cmd_result

  RETURN cmd_result

END FUNCTION

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Marks the state of a transaction block. Subsequent commands will be queued
+ for atomic execution using EXEC.
+ Returns: cmd_result - always returns OK
+
+ For more information, see: http://redis.io/commands/multi
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_multi()

  DEFINE cmd          STRING,
         cmd_result   STRING

  LET cmd = "MULTI"
  CALL exec_redis_command(cmd, NULL, NULL, NULL, NULL, NULL)
  RETURNING cmd_result

  RETURN cmd_result

END FUNCTION

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Executes all previously queued commands in a transaction and restores
+ the connection state to normal.
+ Returns: cmd_result_array - array with each element being the return value
+                             to each of the commands in the atomic 
+                             transaction. The first element is an OK reply from
+                             running the MULTI command.
+                             Can return Null reply if the execution was aborted.
+
+ For more information, see: http://redis.io/commands/exec
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_exec()

  DEFINE cmd               STRING,
         cmd_status        SMALLINT,
         cmd_result        STRING,
         cmd_result_array  DYNAMIC ARRAY OF STRING

  LET cmd = "EXEC"
  CALL exec_redis_command(cmd, NULL, NULL, NULL, NULL, NULL)
  RETURNING cmd_result

  { Seperate by ^ delimiter and place in array }
  CALL delimiter(cmd_result)
  RETURNING cmd_result_array

  RETURN cmd_result_array

END FUNCTION
