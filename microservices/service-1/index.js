const express = require('express')
const bodyParser = require('body-parser')

const AWS = require("aws-sdk")
const eventbridge = new AWS.EventBridge()

const app = express()
const port = 8080

const { pool } = require("./db")

app.use(bodyParser.json())

app.get('/', async (req, res) => {
    try {
        console.log(`${req.url} ${req.method} ${Math.round((new Date()).getTime() / 1000)}`)
        res.status(200).send({
            service: 'service-1',
            res: `Request received on ${Math.round((new Date()).getTime() / 1000)}`
        })
    } catch (e) {
        console.log(e)
    }
})

app.get('/ping', (req, res) => {
    console.log(`${req.url} ${req.method}`)
    res.status(200).send({
        service: 'service-1',
        res: 'PONG'
    })
})

app.post('/users/create', async (req, res) => {
    try {
        console.log(`${req.url} ${req.method} ${Math.round((new Date()).getTime() / 1000)}`)
        const { name } = req.body
        const dbRes = await pool.query(`INSERT INTO users(name, createdat) VALUES ('${name}', '${new Date().toUTCString()}') RETURNING *`)
        // emit user created event
        const user = dbRes.rows;
        res.status(200).send({ res: user })
    } catch (e) {
        console.log(e)
    }
})

app.get('/users/get', async (req, res) => {
    try {
        console.log(`${req.url} ${req.method} ${Math.round((new Date()).getTime() / 1000)}`)
        const dbRes = await pool.query('SELECT * from users ORDER BY random() LIMIT 3;');
        const users = dbRes.rows;
        console.log("fetched users => ", users)
        res.status(200).send({ res: users })
    } catch (e) {
        console.log(e)
    }
})

app.listen(port, () => {
    console.log(`Server listening on http://localhost:${port}`)
})