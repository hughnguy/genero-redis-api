#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>

#include <f2c/fglExt.h>
#include "hiredis_ext.h"

#include <hiredis.h>
#include <async.h>
#include <adapters/libevent.h>

struct event_base *event;
redisAsyncContext *context;

int connectStatus;
char errorMessage[128];

void connectCallback(const redisAsyncContext *c, int status)
{
  connectStatus = REDIS_OK;
  if (status != REDIS_OK)
  {
    connectStatus = REDIS_ERR;
  }
  snprintf(errorMessage, 128, "%s", c->errstr);

  event_base_loopexit(event, NULL);
}


void disconnectCallback(const redisAsyncContext *c, int status)
{
  connectStatus = REDIS_OK;
  if (status != REDIS_OK)
  {
    connectStatus = REDIS_ERR;
  }
  snprintf(errorMessage, 128, "%s", c->errstr);

  event_base_loopexit(event, NULL);
}


void authCommandCallback(redisAsyncContext *c, void *r, void *p)
{
  redisReply *reply = r;

  connectStatus = REDIS_OK;
  if (reply->type == REDIS_REPLY_ERROR)
  {
    connectStatus = REDIS_ERR;
  }
  snprintf(errorMessage, 128, "%s", reply->str);

  event_base_loopexit(event, NULL);
}


/**
 * Connect to redis server at the specified hostname and port.
 * Input: arg1 - hostname
 *        arg2 - hostname length (number of characters)
 *        arg3 - listening port
 *        arg4 - authentication password
 *        arg5 - authentication password length
 * Return: ret1 - connection status (0 = Okay, otherwise error)
 *         ret2 - connection error message, if any.
 */
int redisAsyncConnectExt(int nArgs)
{
  char *hostName = NULL;
  int hostNameLen;
  int port;
  char *passwd = NULL;
  int passwdLen;

  /* pop arguments from stack (in reversed order) */

  popint(&passwdLen);
  passwd = malloc(sizeof(char) * (passwdLen + 1));
  if (passwd == NULL) mallocError("redisAsyncConnectExt()", "passwd");
  popquote(passwd, passwdLen + 1);

  popint(&port);

  popint(&hostNameLen);
  hostName = malloc(sizeof(char) * (hostNameLen + 1));
  if (hostName == NULL) mallocError("redisAsyncConnectExt()", "hostName");
  popquote(hostName, hostNameLen + 1);

  /* reset global variables */
  connectStatus = REDIS_OK;
  errorMessage[0] = '\0';

  /* setup events signaling */
  signal(SIGPIPE, SIG_IGN); // ignore SIGPIPE

  event = event_base_new();
  context = redisAsyncConnect(hostName, port);

  redisLibeventAttach(context, event);
  redisAsyncSetConnectCallback(context, connectCallback);
  redisAsyncSetDisconnectCallback(context, disconnectCallback);
  event_base_dispatch(event);

  /* authenticate if password is provided */
  if (connectStatus == REDIS_OK && passwdLen > 0)
  {
    redisAsyncCommand(context, authCommandCallback, NULL, "AUTH %s", passwd);
    event_base_dispatch(event);
  }

  /* malloc clean up */
  if (hostName != NULL) free(hostName);
  if (passwd != NULL) free(passwd);

  /* push result to stack */
  pushint(connectStatus);
  pushquote(errorMessage, strlen(errorMessage));
  return(2);
}


int redisAsyncDisconnectExt(int nArgs)
{

  /* push result to stack */
  pushint(connectStatus);
  pushquote(errorMessage, strlen(errorMessage));
  return(2);
}
