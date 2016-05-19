#include "f2c/fglExt.h"

/*
 *  This array defines C functions that can be called from BDL.
 *  The last record of each array must be a line with all the
 *  elements set to 0, to define the end of the list.
 */

int redisConnectExt(int nArgs);
int redisDisconnectExt(int nArgs);
int redisCommandExt(int nArgs);

int redisAsyncConnectExt(int nArgs);
int redisAsyncDisconnectExt(int nArgs);

UsrFunction usrFunctions[] = {
  {"redisConnectExt",redisConnectExt,3,2},
  {"redisDisconnectExt",redisDisconnectExt,0,0},
  {"redisCommandExt",redisCommandExt,12,2},

  {"redisAsyncConnectExt",redisAsyncConnectExt,5,2},
  {"redisAsyncDisconnectExt",redisAsyncDisconnectExt,0,2},
  {0,0,0,0}
};

