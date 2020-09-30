//import only required class - DBPool from idb-pconnector 
const { DBPool } = require('idb-pconnector');
//get our utility which formats the date for us 
const formatDate = require('../utils/formatDate')

//Write async function as we will use promise based await while updating the database
async function updateDb(currencyData) {

    // Format the date in IBM i timestamp format as CCYY-MM-DD-HH.MM.SS
    const timestamp = formatDate(currencyData.timestamp)

    // Select required currency to be updated into database from the JSON
    const baseCurr = currencyData.base
    const currUSD = currencyData.rates.USD
    const currEUR = currencyData.rates.EUR
    const currGBP = currencyData.rates.GBP
    const currINR = currencyData.rates.INR
    const currSGD = currencyData.rates.SGD

    // Create a database connection and update the database. 
    try {
        // Connect DB2 using a pool of connection. This is useful for scalability.
        const pool = new DBPool();
        const sql = `Insert into APKHEKALE1.CURRENCY values (?,?,?,?,?,?,?) WITH NONE`
        const params = [timestamp, baseCurr, currUSD, currEUR, currGBP, currINR, currSGD]
        await pool.prepareExecute(sql, params); // prepare and execute the statement 
    } catch (error) { // if something goes wrong, like SQL error, catch those here. 
        console.log(error)
    }
}
//Export the module, so that it can be used from outside this source. 
module.exports = updateDb
