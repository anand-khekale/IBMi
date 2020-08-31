CREATE OR REPLACE PROCEDURE apkhekale1.getForecast(
                IN  Latitude FLOAT,
                IN  Longitude FLOAT,
                IN  APIKEY    VARCHAR(200),
                OUT W_Description VARCHAR(500),
                OUT CurrentTemp FLOAT
            )
        LANGUAGE sql
        RESULT SETS 0
BEGIN

SELECT W_Desc, Temp
    INTO W_Description, CurrentTemp
    FROM JSON_TABLE(
SYSTOOLS.HTTPGETCLOB(
  'http://api.weatherstack.com/current?access_key=' CONCAT 
          SYSTOOLS.URLENCODE(TRIM(APIKEY), '') CONCAT 
          '&query=' CONCAT
          SYSTOOLS.URLENCODE(Latitude,'') CONCAT
          ',' CONCAT
          SYSTOOLS.URLENCODE(Longitude,''), NULL
  ),
  '$'
  COLUMNS
  (W_Desc  VARCHAR(500) path '$.current.weather_descriptions[0]',
   Temp    FLOAT        path '$.current.temperature'
  )error on error
  ) as x;
  END


  call apkhekale1.getForecast(18.50,73.70,'b2c57a9741b8de0d0d38e10f3bd69a03','','')