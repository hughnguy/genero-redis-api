#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <time.h>
#include <sys/time.h>
#include <f2c/fglExt.h>

#include "hiredis.h"
#include "hiredis_ext.h"

static redisContext *context = NULL;

/**
 * Connect to redis server at the specified hostname and port.
 * Input: arg1 - hostname
 *        arg2 - hostname length (number of characters)
 *        arg3 - listening port
 * Return: ret1 - connection status (0 = Okay, otherwise error)
 *         ret2 - connection error message, if any.
 */
int redisConnectExt(int nArgs)
{
  char *hostName = NULL;    /* 1st arg: hostname */
  int hostNameLen;          /* 2nd arg: hostname length */
  int port;                 /* 3rd arg: redis port */

  int connectStatus;        /* 1st return: connection status (REDIS_OK or REDIS_ERR) */
  char errorMsg[128 + 1];   /* 2nd return: error message (if any) */

  struct timeval timeout = { 1, 500000 }; /* 1.5 seconds */

  /* pop arguments from stack (in reversed order)*/
  popint(&port);
  popint(&hostNameLen);
  hostName = malloc(sizeof(char) * (hostNameLen + 1));
  if (hostName == NULL) mallocError("redisapiConnect()", "hostName");
  popquote(hostName, hostNameLen + 1);

  /* connect to redis server (libhiredis.so) */
  context = redisConnectWithTimeout(hostName, port, timeout);
  if (context == NULL || context->err)
  {
    connectStatus = REDIS_ERR;
    strncpy(errorMsg, context->errstr, 128);
    errorMsg[128] = '\0';

    /* clean up context*/
    if (context != NULL)
    {
      redisFree(context);
      context = NULL;
    }
  }
  else
  {
    connectStatus = REDIS_OK;
    errorMsg[0] = '\0';
  }

  /* push result to stack  */
  pushint(connectStatus);
  pushquote(errorMsg, strlen(errorMsg));

  /* free allocated memory */
  if (hostName != NULL) free(hostName);

  return(2);
}


/**
 * Disconnect from redis server and reset the context
 * Input: nill
 * Return: always 0.
 */
int redisDisconnectExt(int nArgs)
{
  if (context != NULL)
  {
    redisFree(context);
    context = NULL;
  }

  return(0);
}


/**
 * Execute the redis command.  Note that redis must be connected, otherwise
 * it will fail with an error code.
 * Input: arg1 - redis command
 *        arg2 - redis command length
 *        arg3 - redis command param1
 *        arg4 - redis command param1 length
 *        arg5 - redis command param2 
 *        arg6 - redis command param2 length
 *        arg7 - redis command param3
 *        arg8 - redis command param3 length
 *        arg9 - redis command param4
 *        arg10- redis command param4 length
 *        arg11- redis command param5
 *        arg12- redis command param5 length
 *
 * Return: ret1 - command status (0 = success)
 *         ret2 - command results.  Note that if the command results is
 *                an array of data, the data will be delimited by a '^'
 *                character. If a 2D array is returned, then all elements
 *                of each nested array will return delimited by '^' as well.
 */
int redisCommandExt(int nArgs)
{
  char *command = NULL; 
  int   commandLen;     
  char *param1 = NULL; 
  int   param1Len;    
  char *param2 = NULL;
  int   param2Len;    
  char *param3 = NULL;
  int   param3Len;    
  char *param4 = NULL;
  int   param4Len;
  char *param5 = NULL;
  int   param5Len;

  char *result = NULL;
  int   result_size;

  int   commandStatus;

  result_size  = 0;

  /* other variables */
  redisReply *reply = NULL;
  int resultLen = 0;
  char rec_sep = REC_SEPARATOR;
  int i; /* for loop incrementer */
  int r; /* for nested loop incrementer */
  int array2d; /* boolean to indicate 2d array */

  /* pop arguments from stack */

  popint(&param5Len);
  param5 = malloc(sizeof(char) * (param5Len + 1));
  if (param5 == NULL) mallocError("redisapiCommand()", "param5");
  popquote(param5, param5Len + 1);

  popint(&param4Len);
  param4 = malloc(sizeof(char) * (param4Len + 1));
  if (param4 == NULL) mallocError("redisapiCommand()", "param4");
  popquote(param4, param4Len + 1);

  popint(&param3Len);
  param3 = malloc(sizeof(char) * (param3Len + 1));
  if (param3 == NULL) mallocError("redisapiCommand()", "param3");
  popquote(param3, param3Len + 1);

  popint(&param2Len);
  param2 = malloc(sizeof(char) * (param2Len + 1));
  if (param2 == NULL) mallocError("redisapiCommand()", "param2");
  popquote(param2, param2Len + 1);

  popint(&param1Len);
  param1 = malloc(sizeof(char) * (param1Len + 1));
  if (param1 == NULL) mallocError("redisapiCommand()", "param1");
  popquote(param1, param1Len + 1);

  popint(&commandLen);
  command = malloc(sizeof(char) * (commandLen + 1));
  if (command == NULL) mallocError("redisapiCommand()", "command");
  popquote(command, commandLen + 1);

  if (context == NULL || context->err)
  {
    commandStatus = REDIS_ERR;
    result = malloc(sizeof(char) * (128 + 1));
    result_size = 129;
    if (result == NULL) mallocError("redisapiCommand()", "result");
    sprintf(result, "Redis context not inialized.");
  }
  else
  {
    /* execute redis command */
    if (param5Len > 0 )
    {
      reply = redisCommand(context, "%s %s %s %s %s %s", command, param1, param2, param3, param4, param5);
    }
    else if (param4Len > 0)
    {
      reply = redisCommand(context, "%s %s %s %s %s", command, param1, param2, param3, param4);
    }
    else if (param3Len > 0)
    {
      reply = redisCommand(context, "%s %s %s %s", command, param1, param2, param3);
    }
    else if (param2Len > 0)
    {
      reply = redisCommand(context, "%s %s %s", command, param1, param2);
    }
    else if (param1Len > 0)
    {
      reply = redisCommand(context, "%s %s", command, param1);
    }
    else if (commandLen > 0)
    {
      reply = redisCommand(context, command);
    }

    if (reply == NULL)
    {
      commandStatus = REDIS_ERR;
      result = malloc(sizeof(char) * (128 + 1));
      result_size = 129;
      if (result == NULL) mallocError("redisapiCommand()", "result");
      sprintf(result, "Redis command execute failed (no reply).");
    }
    else
    {
      /* parse redis reply */
      switch (reply->type)
      {
        case REDIS_REPLY_ERROR:
          commandStatus = REDIS_COMM_ERR; /* Command error */
          if (reply->len > 0)
          {
            result = malloc(sizeof(char) * (reply->len + 1));
            result_size = reply->len + 1;
            if (result == NULL) mallocError("redisapiCommand()", "result");
            strncpy(result, reply->str, reply->len);
            result[reply->len] = '\0';
          }
          break;

        case REDIS_REPLY_INTEGER:
          commandStatus = REDIS_OK;
          result = malloc(sizeof(char) * (64 + 1));
          result_size = 65;
          if (result == NULL) mallocError("redisapiCommand()", "result");
          sprintf(result, "%lld", reply->integer);
          break;

        case REDIS_REPLY_STRING:
          commandStatus = REDIS_OK;
          if (reply->len > 0)
          {
            result = malloc(sizeof(char) * reply->len + 1);
            result_size = reply->len + 1;
            if (result == NULL) mallocError("redisapiCommand()", "result");
            strncpy(result, reply->str, reply->len);
            result[reply->len] = '\0';
          }
          break;

        case REDIS_REPLY_ARRAY:
          commandStatus = REDIS_OK;
          if (reply->elements == 0){
            result = NULL;
            break;
          }
          
          /* Check if 2D array */
          if (reply->element[0]->type == REDIS_REPLY_ARRAY)
          {
            array2d = 1;
          }
          else
          {
            array2d = 0;
          }
          
          /* figure out how much space we need to allocate, */
          /* we add 1 for the record separator. */
          for (i = 0; i < reply->elements; i++)
          {
	    if (array2d == 0) /* If 1D array */
            {
              resultLen += reply->element[i]->len + 1;
	    }
            else /* If 2D array */
            {
              for (r = 0; r < reply->element[i]->elements; r++)
              {
                resultLen += reply->element[i]->element[r]->len + 1;
              }
	    }
          }

          /* allocate the memory and concatenate the results */
          if (resultLen>0)
          {
            result = malloc(sizeof(char) * (resultLen + 1));
            result_size = resultLen + 1;
            memset(result, 0, result_size);
            if (result == NULL) mallocError("redisapiCommand()", "result");

            for (i = 0; i < reply->elements; i++)
            {
              if (array2d == 0) /* If 1D array */
              {
		if (reply->element[i]->str != NULL)
		{
		  if (i == 0)
		  {
		    strncpy(result, reply->element[i]->str, reply->element[i]->len+1);
		    strncat(result, &rec_sep, sizeof(char));
		  }
		  else
		  {
		    strncat(result, reply->element[i]->str, reply->element[i]->len+1);
		    strncat(result, &rec_sep, sizeof(char));
		  }
		}
              }
              else /* If 2D array */
              {
                for (r = 0; r < reply->element[i]->elements; r++)
                {
                  if (reply->element[i]->element[r]->str != NULL)
                  {
                    if (i == 0 && r == 0)
                    {
                      strncpy(result, reply->element[i]->element[r]->str,
                                      reply->element[i]->element[r]->len+1);
                      strncat(result, &rec_sep, sizeof(char));
                    }
                    else
                    {
                      strncat(result, reply->element[i]->element[r]->str,
                                      reply->element[i]->element[r]->len+1);
                      strncat(result, &rec_sep, sizeof(char));
                    }
                  }
                }
              }
            }
            result[resultLen] = '\0';
          }
          break;

        default:
          commandStatus = REDIS_OK;
          if (reply->len > 0)
          {
            result = malloc(sizeof(char) * (reply->len + 1));
            result_size = reply->len + 1;
            if (result == NULL) mallocError("redisapiCommand()", "result");
            strncpy(result, reply->str, reply->len);
            result[reply->len] = '\0';
          }
          break;
      }
    }
  }

  /* push results to stack */
  pushint(commandStatus);

  if(result != NULL)
  {
    pushquote(result, strnlen(result,result_size));
  }
  else
  {
    pushquote("", 0);
  }

  /* free allocated memory */
  if (reply != NULL) freeReplyObject(reply);

  if (command != NULL) free(command);
  if (param1 != NULL) free(param1);
  if (param2 != NULL) free(param2);
  if (param3 != NULL) free(param3);
  if (param4 != NULL) free(param4);
  if (param5 != NULL) free(param5);
  if (result != NULL) free(result);

  return(2);
}

