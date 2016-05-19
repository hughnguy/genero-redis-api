#include <stdio.h>
#include <stdlib.h>
#include <string.h>


void mallocError(char *funcName, char *varName);

void mallocError(char *funcName, char *varName)
{
  printf("ERROR: memory allocation failed in %s - %s\n", funcName, varName);
  exit(-1);
}


