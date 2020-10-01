// import our getCurrency function from utils directory, this is similar to /COPY in RPGLE
const getCurrency = require('./utils/getCurrency');
// import our updateDb function from db directory
const updateDb = require('./db/updateDb');

const baseCurr = process.argv[2]; // accept base currency from command line

//If base currency is not entered, give error and exit the program.
if (!baseCurr) { return console.log('Base Currency not entered') }

/* Call getCurrency function passing base currency and a callback function. 
   The getCurrency will give a call to callback with appropriate parameters,
   if it is successful it will have currency data, else it will have error, but not both. */
getCurrency(baseCurr, (error, currencyData) => {
    if (error) {
        console.log(error);
    } else {
        // call updateDb for updating the data into DB2 with currency rates. 
        updateDb(currencyData).catch((error) => {
            console.error(error);
        })
    }
})
