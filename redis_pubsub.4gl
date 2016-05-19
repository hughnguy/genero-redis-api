{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Redis PUB/SUB commands module.
+ This module contains functions to perform PUB/SUB comamnds:
+   - PUBLISH channel message
+   - 
+
+ For more information, see: http://redis.io/commands#pubsub
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{ Import C libray }
IMPORT libhiredisext

{ Import global variables }
GLOBALS "redis_globals.4gl"

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Posts a message to the given channel
+ Where: channel - the channel to post message
+        message - the message to post to the channel
+ Returns: cmd_result - the number of clients that received the message
+
+ For more information, see: http://redis.io/commands/publish
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_publish(channel, message)

  DEFINE channel      STRING,
         message      STRING,
         cmd          STRING,
         cmd_result   STRING

  LET cmd = "PUBLISH"
  CALL exec_redis_command(cmd, channel, message, NULL, NULL, NULL)
  RETURNING cmd_result

  RETURN cmd_result

END FUNCTION

