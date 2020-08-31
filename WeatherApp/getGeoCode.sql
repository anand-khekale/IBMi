CREATE OR REPLACE PROCEDURE apkhekale1.getGeoCode(
                IN  City      CHAR(50),
                IN  APIKEY    VARCHAR(200),
                OUT Latitude FLOAT,
                OUT Longitude FLOAT,
                OUT Place     VARCHAR(100)
            )
        LANGUAGE SQL
        RESULT SETS 0
BEGIN

SELECT Lat, Lon, PName
    INTO Latitude, Longitude, Place
    FROM JSON_TABLE(
SYSTOOLS.HTTPGETCLOB(
  'https://api.mapbox.com/geocoding/v5/mapbox.places/' CONCAT 
          SYSTOOLS.URLENCODE(TRIM(City), '') CONCAT 
          '.json?access_token=' CONCAT
          SYSTOOLS.URLENCODE(TRIM(APIKEY),'') CONCAT
          '&limit=' CONCAT
          SYSTOOLS.URLENCODE('1',''), NULL
  ),
  '$'
  COLUMNS
  (Lat    FLOAT     path '$.features[0].center[1]',
   Lon    FLOAT     path '$.features[0].center[0]',
   PName  CHAR(100) path '$.features[0].place_name'
  )error on error
  ) as x;
  END

  call apkhekale1.getGeoCode('Pune','pk.eyJ1IjoiYXBraGVrYWxlIiwiYSI6ImNrY2FoajExNTFzeHYyc3Fwajg2ZmF1b2kifQ.YSNiJ5LvG3wDMYQvyQepwA', '','','')