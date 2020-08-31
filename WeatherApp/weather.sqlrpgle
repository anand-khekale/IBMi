**FREE
//========================================================================*
Ctl-Opt DftActGrp(*No) Option(*Srcstmt : *NodebugIO);
//========================================================================*
// This program consumes Mapbox & WeatherStack APIs to get latest weather
// information for the city entered. It receives the JSON data by
// using HTTPGETCLOB. JSON is parsed by using JSON_TABLE SQL function.
//
// Mapbox API Signup - https://account.mapbox.com/auth/signup/
// Mapbox API accepts city as string and returns Latitude, Longitude for it.
//
// Weatherstack API Signup - https://weatherstack.com/signup/free
// Weatherstack API accepts Latitude, Longitude and provides weather
// information.
//
// The green screen version is just to demonstrate that IBM i can consume and
// publish data natively to the web.
//
// https://www.anandk.dev
//========================================================================*
// Files
//------------------------------------------------------------------------*
Dcl-F WEATHERDS WORKSTN;
//========================================================================*
// Data Structures - System
//------------------------------------------------------------------------*
Dcl-DS *N  PSDS;
    #Prog          Char(10)   Pos(1);
    #JobName       Char(10)   Pos(244);
    #User          Char(10)   Pos(254);
    #JobNo         Zoned(6:0) Pos(264);
End-DS;
//========================================================================*
// External program calls
//------------------------------------------------------------------------*
dcl-pr getenv pointer extproc('getenv');
        *n pointer value options(*string:*trim);
end-pr;

dcl-pr setEnv         extpgm('SETENV');
end-pr;
//========================================================================*
// Switches
//------------------------------------------------------------------------*
Dcl-S ExitProcessScreen   Char(1);
Dcl-S ValidScreen         Char(1);
//========================================================================*
// Program variable definitions...
//------------------------------------------------------------------------*
Dcl-S weatherDesc         Char(100) Inz;
Dcl-S temperature         Zoned(5:2) Inz;
Dcl-S Latitude            Zoned(6:3) Inz;
Dcl-S Longitude           Zoned(6:3) Inz;
Dcl-S city                Char(20) Inz;
Dcl-S MAPBOX_KEY          Varchar(200) Inz;
Dcl-S WSTACK_KEY          Varchar(200) Inz;
Dcl-S Place               char(100) Inz;
//========================================================================*
// Main Processing
//------------------------------------------------------------------------*
ExitProcessScreen = 'N';
Exsr Init;
Exsr ProcessScreen;
*InLR = *On;
Return;
//========================================================================*
// Process Screen
//------------------------------------------------------------------------*
Begsr ProcessScreen;

    Exsr ResetErrorInd;

    Dow ExitProcessScreen = 'N';

        Exsr DisplayScreen;
        Exsr AcceptScreen;
        Exsr ValidateScreen;

        If ExitProcessScreen = 'Y';
            Leavesr;
        Endif;

        If ValidScreen = 'Y';
            Exsr ResetErrorInd;
            Exsr getWeather;
        Endif;

    Enddo;

Endsr;
//========================================================================*
// Validate Screen
//------------------------------------------------------------------------*
Begsr ValidateScreen;

    ValidScreen = 'Y';
    WTEXT = *Blanks;
    CURTEMP = *Zeros;
    WTEXT = *Blanks;
    CURTEMP = *Zeros;
    WPLACE = *Blanks;

    Exsr ResetErrorInd;

    If *In03 = *On;
        ExitProcessScreen = 'Y';
        Leavesr;
    Endif;

    If WCITY = *Blanks;
        ValidScreen = 'N';
        ERRMSG = 'City must be entered';
        Leavesr;
    Endif;

Endsr;
//========================================================================*
// Get Weather information by fetching Latitude, Longitude for the city
// entered. Then fetch the weather forecast.
//------------------------------------------------------------------------*
Begsr GetWeather;

    city = WCITY;
    Latitude = *Zeros;
    Longitude = *Zeros;
    Place = *Blanks;

    Exec Sql
        call getGeoCode(:city, :MAPBOX_KEY, :Latitude, :Longitude, :Place);

    If SQLCODE <> *Zeros;
        ERRMSG = 'City entered may be wrong, cannot fetch weather information';
        Leavesr;
    Endif;

    //
    weatherDesc = *Blanks;
    temperature = *Zeros;

    Exec SQL
        call getForecast(:Latitude, :Longitude, :WSTACK_KEY,
                              :weatherDesc, :temperature);

    If SQLCODE = *Zeros;
        WTEXT = weatherDesc;
        CURTEMP = temperature;
        WPLACE = Place;
    Else;
        ERRMSG = 'Unable to fetch weather information at the moment';
        Leavesr;
    Endif;

Endsr;
//========================================================================*
// Display the screen
//------------------------------------------------------------------------*
Begsr DisplayScreen;

    If ERRMSG <> *Blanks;
        *In50 = *On;
    Endif;

    Write WEATHER01;

Endsr;
//========================================================================*
// Accept the screen
//------------------------------------------------------------------------*
Begsr AcceptScreen;

    Read WEATHER01;

Endsr;
//========================================================================*
// Reset Error Indicators & Error Message
//------------------------------------------------------------------------*
Begsr ResetErrorInd;

    ERRMSG = *Blanks;
    *In50 = *Off;

Endsr;
//========================================================================*
// Initialize
//------------------------------------------------------------------------*
Begsr Init;

    // Set environment variables with API Keys, setEnv is a CL program
    // which uses ADDENVVAR to set the keys. (This is to mask the keys from
    // this source code which will be in GitHub).

    setEnv();

    // Get API key stored setENV

    MAPBOX_KEY = %str(getenv('MAPBOX_KEY')) ;
    WSTACK_KEY = %str(getenv('WEATHERSTACK_KEY')) ;

Endsr;
//========================================================================*
