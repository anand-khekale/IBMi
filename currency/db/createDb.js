// import required class - DBPoll from idb-pconnector for connection to DB2
const { DBPool } = require('idb-pconnector');

// Keep the SQL statement ready
const sql = `CREATE OR REPLACE TABLE APKHEKALE1.CURRENCY(
                Date Timestamp(0),
                BCURR CHAR(3),
                USD Decimal(12, 4),
                EUR Decimal(12, 4),
                GBP Decimal(12, 4),
                INR Decimal(12, 4),
                SGD Decimal(12, 4)) RCDFMT RCURRENCY`;

const label = `LABEL ON COLUMN APKHEKALE1.CURRENCY (
                Date TEXT IS 'Date fetched',
                BCURR TEXT IS 'Base Currency',
                USD  TEXT IS 'United States Dollar',
                EUR  TEXT IS 'Euro',
                GBP  TEXT IS 'Pound sterling',
                INR  TEXT IS 'Indian Rupee',
                SGD  TEXT IS 'Singapore Dollars')`;

const colhdg = `LABEL ON COLUMN APKHEKALE1.CURRENCY (
                Date  IS 'Date fetched',
                BCURR IS 'Base Currency',
                USD   IS 'United States Dollar',
                EUR  IS 'Euro',
                GBP  IS 'Pound sterling',
                INR  IS 'Indian Rupee',
                SGD  IS 'Singapore Dollars')`;
// Write async - promised based function so that await can be used
async function createDB() {

    try {
        const pool = new DBPool(); //Create a new instance of pool
        const connection = pool.attach(); // create the connection
        const statement = connection.getStatement(); //create new instance of statement
        // execute and await each statement, if something goes wrong, we will be in error block. 
        await statement.prepare(sql);
        await statement.execute();
        await statement.prepare(label);
        await statement.execute();
        await statement.prepare(colhdg);
        await statement.execute();

        await pool.detach(connection); //Once done, detach/close the connection 
    } catch (error) {
        console.log(error);
    }
}

//call the function and catch errors, if any.
createDB().catch((error) => {
    console.error(error);
})