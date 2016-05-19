#!/bin/sh

# Sync Modules

fglcomp -Wall redis_test.4gl
fglcomp -Wall test_connection.4gl
fglcomp -Wall test_strings.4gl
fglcomp -Wall test_sets.4gl
fglcomp -Wall test_keys.4gl
fglcomp -Wall test_hashes.4gl
fglcomp -Wall test_pubsub.4gl
fglcomp -Wall test_server.4gl
fglcomp -Wall test_transactions.4gl
fglcomp -Wall test_geo.4gl

fgllink -o redis_test.42r libredisfgl.42x \
	redis_test.42m \
        test_connection.42m \
	test_strings.42m \
        test_sets.42m \
        test_keys.42m \
        test_hashes.42m \
        test_pubsub.42m \
        test_server.42m \
        test_transactions.42m \
        test_geo.42m


# Async Module

fglcomp -Wall async_test.4gl

fgllink -o async_test.42r libredisfgl.42x \
	async_test.42m \
