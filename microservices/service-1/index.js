require('dotenv').config()

const express = require('express')
const bodyParser = require('body-parser')
const { ulid } = require('ulid')

const AWS = require("aws-sdk")
AWS.config.update({ region: 'us-east-1', accessKeyId: process.env.AWSACCESSKEY, secretAccessKey: process.env.AWSSECRET });
const eventbridge = new AWS.EventBridge()

const app = express()
const port = 8080

const { pool } = require("./db")

app.use(bodyParser.json())

app.get('/service/info', async (req, res) => {
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

app.get('/ping', async (req, res) => {
    try {
        console.log(`${req.url} ${req.method}`)
        res.status(200).send({
            service: 'service-1',
            res: 'PONG'
        })
    } catch (e) {
        console.log(e)
    }
})

async function emitEvent(source, eventBus, detailType, time, detail) {
    const params = {
        Entries: [
            {
                Source: source,
                EventBusName: eventBus,
                DetailType: detailType,
                Time: time,
                Detail: JSON.stringify(detail)
            },
        ]
    };
    await eventbridge.putEvents(params, function (err, data) {
        if (err) console.log(err, err.stack); // an error occurred
        else console.log(data);           // successful response
    });
};

app.post('/orders/create', async (req, res) => {
    try {
        console.log(`${req.url} ${req.method} ${Math.round((new Date()).getTime() / 1000)}`)
        const { item, quantity, userid } = req.body
        const dbRes = await pool.query(`INSERT INTO orders(orderid, item, quantity, userid, createdat) VALUES ('${ulid()}', '${item}', ${quantity}, '${userid}', '${new Date().toUTCString()}') RETURNING *`)
        // put order created event into eventBus
        const order = dbRes.rows;
        await emitEvent('custom.parikpanchal', 'microenterprise-dev-event-bus', 'order', new Date(), {
            "order": order
        });
        res.status(200).send({ res: order })
    } catch (e) {
        console.log(e)
    }
})

app.get('/orders/get', async (req, res) => {
    try {
        console.log(`${req.url} ${req.method} ${Math.round((new Date()).getTime() / 1000)}`)
        const dbRes = await pool.query('SELECT * from orders;');
        const orders = dbRes.rows;
        console.log("fetched orders => ", orders)
        res.status(200).send({ res: orders })
    } catch (e) {
        console.log(e)
    }
})

app.listen(port, () => {
    console.log(`Server listening on http://localhost:${port}`)
})