#ident  "@(#)makefile   %I% 87/01/01"
#
# Last Update Date: July 07/93  Versadex III Ver: 4.4
#
# See README file for the documentation for the makefile
############################################################################
#

SHELL = /bin/sh
EXEC_DIR =

############################################################################
# Define paths to source file locations other than local directory.
############################################################################


############################################################################
# Define exact search path for "*.h" files.
############################################################################

CUSTOM_INCL = -I$(VDXTOOLS)/include/hiredis 

############################################################################
# Read in compile commands and library settings.
############################################################################

include ../../include/vdx.mk

REDIS_C_GRP = hiredis_ext.o hiredis_common.o hiredis_sync.o \
	hiredis_async.o

REDIS_FGL_GRP = redis_globals.42m redis_connection.42m redis_geo.42m \
	redis_hashes.42m redis_keys.42m redis_lists.42m redis_pubsub.42m \
	redis_server.42m redis_sets.42m redis_strings.42m \
	redis_transactions.42m redis_async.42m redis_common.42m \

############################################################################
#  Shared object
############################################################################

$(EXEC_DIR)42m/libhiredisext.so: $(REDIS_C_GRP)
	$(LINKSO) $(EXEC_DIR)42m/libhiredisext.so $(REDIS_C_GRP) \
	$(LINKSOFLAGS) -lhiredis -levent

$(EXEC_DIR)42m/libredisfgl.42x: $(REDIS_FGL_GRP)
	$(PLOAD) $(FGLLINKOPTS) $(EXEC_DIR)42m/libredisfgl.42x $(REDIS_FGL_GRP)

############################################################################
# Build instructions for all suffixes.
############################################################################

.IGNORE:
.SUFFIXES: .o .42m .c .4gl .all

.all.42m:
	if [ -f $*.42m ]; then rm -f $*.42m; fi
	cp $*.all $*.4gl
	$(P4GL) $*.4gl
	@( if [ ! -z "$(EXEC_DIR)" ]; then \
	  $(PCOPYOBJ); \
	fi )
	$(REMOVE_EC)
	@( if [ ! "`basename $*.42m`" = "$*.42m" ]; then \
	  $(MOVEOBJ); \
	  $(REMOVE_EC); \
	fi )

.4gl.42m:
	if [ -f $*.42m ]; then /bin/rm -f $*.42m; fi
	$(P4GL) $*.4gl
	@( if [ ! -z "$(EXEC_DIR)" ]; then \
		$(PCOPYOBJ); \
	fi )
	@( if [ ! "`basename $*.42m`" = "$*.42m" ]; then \
		$(MOVEOBJ); \
	fi )

.c.o:
	@( if [ -f $*.ec ]; then rm -f $*.c; fi )
	@( if [ -f $*.o ]; then rm -f $*.o; fi )
	$(CC) $(CFLAGS) -c $*.c
	@( if [ ! "`basename $*.o`" = "$*.o" ]; then \
	  $(MOVECOBJ); \
	fi )
#
############################################################################
