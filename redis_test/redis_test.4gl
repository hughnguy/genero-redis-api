MAIN

  CALL STARTLOG("redis_test.log")
  { Run tests for redis connection group commands }
  CALL test_connection()
  { Run tests for redis strings group commands }
  CALL test_strings()
  { Run tests for redis sets group commands }
  CALL test_sets()
  { Run tests for redis keys group commands }
  CALL test_keys()
  { Run tests for redis hashes group commands }
  CALL test_hashes()
  { Run tests for redis pubsub group commands }
  CALL test_pubsub()
  { Run tests for redis server group commands }
  CALL test_server()
  { Run tests for redis transactions group commands }
  CALL test_transactions()
  { Run tests for redis geo group commands }
  CALL test_geo()

END MAIN

