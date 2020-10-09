// Import Needle library that we installed, to issue HTTP GET request.
var needle = require('needle');
// Assign API key that we received from https://openexchangerates.org/signup/free
const API_KEY = 'YOUR-KEY-FROM-OPEN-EXCHANGE-RATES';

const getCurrency = (baseCurr, callback) => {
    const url = `https://openexchangerates.org/api/latest.json?app_id=${API_KEY}&base=${baseCurr}`
    needle.get(url, function (error, response) {
        if (error) { //Check if there are any communication errors
            callback('Unable to connect to currency services', undefined);
        } else if (response.body.error) { // Check if we received any error from API
            callback({ "error": response.body.description }, undefined);
        } else if (!error && response.statusCode == 200) { // All went well and we have the needed data
            callback(undefined, response.body); // Call the callback with no error and data
        }
    })
}
/* Since we will be using getCurrency from outside this source, we need to export it, similarly as
   we do with RPGLE procedures                                                                     */
module.exports = getCurrency;
