require('dotenv').config()

const Pool = require('pg').Pool

const pool = new Pool({
    user: process.env.PGUSER,
    host: process.env.PGHOST,
    database: process.env.PGDBNAME,
    password: process.env.PGDBPASSWORD,
    port: process.env.PGPORT
})

module.exports = {
    pool
}
