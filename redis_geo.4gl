{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Redis GEO commands module.
+ This module contains functions to perform GEO comamnds:
+   - GEOADD
+   - GEOHASH
+   - GEOPOS
+   - GEODIST
+   - GEORADIUS 
+   - GEORADIUSBYMEMBER
+
+ For more information, see: http://redis.io/commands#geo
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{ Import C library }
IMPORT libhiredisext

{ Import global variables }
GLOBALS "redis_globals.4gl"

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Adds the specified geospatial item (longitude, latitude, name) to the
+ specified key.
+ Where: key - key to set geospatial item in
+        longitude - the longitude of geospatial item
+        latitude - the latitude of geospatial item
+        member - the name of member
+ Returns: cmd_result - returns: the number of elements added to the set
+                                not including already existing elements that
+                                were updated.
+
+ For more information, see: http://redis.io/commands/geoadd
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_geoadd(key, longitude, latitude, member)

  DEFINE key          STRING,
         longitude    STRING,
         latitude     STRING,
         member       STRING,
         cmd          STRING,
         cmd_result   STRING

  LET cmd = "GEOADD"
  CALL exec_redis_command(cmd, key, longitude, latitude, member, NULL)
  RETURNING cmd_result

  RETURN cmd_result

END FUNCTION

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Returns valid geohash strings representing the position of one or more
+ elements
+ Where: key - key to of geospatial item
+        members - array of members
+ Returns: cmd_result_array - array where each element is the geohash
+                             corresponding to each member named passed as
+                             argument to the command.
+
+ For more information, see: http://redis.io/commands/geohash
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_geohash(key, members)

  DEFINE key               STRING,
         members           DYNAMIC ARRAY OF STRING,
         buffer            base.StringBuffer,
         idx               INTEGER,
         cmd               STRING,
         cmd_result        STRING,
         cmd_result_array  DYNAMIC ARRAY OF STRING

  LET cmd = "GEOHASH"
  LET buffer = base.StringBuffer.create()
  CALL buffer.append(cmd || " " || key)

  FOR idx = 1 TO members.getLength()
    CALL buffer.append(" " || members[idx])
  END FOR

  LET cmd = buffer.toString()

  CALL exec_redis_command(cmd, NULL, NULL, NULL, NULL, NULL)
  RETURNING cmd_result

  { Seperate by ^ delimiter and place in array }
  CALL delimiter(cmd_result)
  RETURNING cmd_result_array

  RETURN cmd_result_array

END FUNCTION

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Return a 2D array of positions (longitude, latitude) of all the specified
+ members of the geospatial index represented by the sorted set at key
+ Where: key - the key 
+        members - array of members
+ Returns: cmd_result_array - array where each element is a two elements array
+                             representing longitude and latitude (x,y) of each
+                             member name passed as argument to the command.
+
+ For more information, see: http://redis.io/commands/geopos
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_geopos(key, members)

  DEFINE key               STRING,
         members           DYNAMIC ARRAY OF STRING,
         buffer            base.StringBuffer, 
         idx               INTEGER,
         cmd               STRING,
         cmd_result        STRING,
         cmd_result_array  DYNAMIC ARRAY OF redis_coordinate

  LET cmd = "GEOPOS"
  LET buffer = base.StringBuffer.create()
  CALL buffer.append(cmd || " " || key)

  FOR idx = 1 TO members.getLength()
    CALL buffer.append(" " || members[idx])
  END FOR

  LET cmd = buffer.toString()

  CALL exec_redis_command(cmd, NULL, NULL, NULL, NULL, NULL)
  RETURNING cmd_result

  { Seperate by ^ delimiter and place in array }
  CALL geoposDelimiter(cmd_result)
  RETURNING cmd_result_array

  RETURN cmd_result_array

END FUNCTION

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Return the distance between two members in the geospatial index
+ Where: key - key of member
+        member1 - the first member
+        member2 - the second member
+        unit - the unit of measure (m, km, mi, ft)
+ Returns: cmd_result - the distance between the two members
+
+ For more information, see: http://redis.io/commands/geodist
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_geodist(key, member1, member2, unit)

  DEFINE key          STRING,
         member1      STRING,
         member2      STRING,
         unit         STRING,
         cmd          STRING,
         cmd_result   STRING

  LET cmd = "GEODIST"
  CALL exec_redis_command(cmd, key, member1, member2, unit, NULL)
  RETURNING cmd_result

  RETURN cmd_result

END FUNCTION

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ Return the members of a sorted set populated with geospatial information
+ using GEOADD, which are within the borders of the area specified with the
+ center location and the maximum distance from the center (radius)
+ Where: key - key
+        longitude - the longitude
+        latitude - the latitude
+        radius - the radius
+        unit - the unit (m, km, ft, mi)
+ Returns: cmd_result_array - an array of members
+
+ For more information, see: http://redis.io/commands/georadius
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_georadius(key, longitude, latitude, radius, unit)

  DEFINE key                STRING,
         longitude          STRING,
         latitude           STRING,
         radius             STRING,
         unit               STRING,
         cmd                STRING,
         cmd_result         STRING,
         cmd_result_array   DYNAMIC ARRAY OF STRING

  LET cmd = "GEORADIUS"
  CALL exec_redis_command(cmd, key, longitude, latitude, radius, unit)
  RETURNING cmd_result

  { Seperate by ^ delimiter and place in array }
  CALL delimiter(cmd_result)
  RETURNING cmd_result_array

  RETURN cmd_result_array

END FUNCTION

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+ This command is exactly like GEORADIUS but instead of taking a longitude
+ and latitude, it takes the name of a member already existing insde the 
+ geospatial index represented by the sorted set.
+ Where: key - key
+        member - the member
+        radius - the radius
+        unit - the unit (m, km, ft, mi)
+ Returns: cmd_result_array - an array of members
+
+ For more information, see: http://redis.io/commands/georadius
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION redis_georadius_bymember(key, member, radius, unit)

  DEFINE key                STRING,
         member             STRING,
         radius             STRING,
         unit               STRING,
         cmd                STRING,
         cmd_result         STRING,
         cmd_result_array   DYNAMIC ARRAY OF STRING

  LET cmd = "GEORADIUSBYMEMBER"
  CALL exec_redis_command(cmd, key, member, radius, unit, NULL)
  RETURNING cmd_result

  { Seperate by ^ delimiter and place in array }
  CALL delimiter(cmd_result)
  RETURNING cmd_result_array

  RETURN cmd_result_array

END FUNCTION

