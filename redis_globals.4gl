GLOBALS

  CONSTANT REDIS_OK = 0
  CONSTANT REDIS_ERROR = -1
  CONSTANT REDIS_CMD_ERROR = -2

  CONSTANT RECORD_SEPARATOR = '^'

  CONSTANT CONNECT_ERR_MSG = 'A connection error occurred.'

  DEFINE redis_host       STRING
  DEFINE redis_port       SMALLINT
  DEFINE redis_password   STRING
  { Indicate if we are already connected to redis }
  DEFINE redis_connected  SMALLINT
  
  -- make this lowercase
  TYPE redis_coordinate   RECORD
			    longitude STRING,
			    latitude  STRING
			  END RECORD

END GLOBALS


