const express = require('express')
const AWS = require("aws-sdk")
const eventbridge = new AWS.EventBridge()

const app = express()
const port = 4000

app.post('/orders/create', (req, res) => {
    // check if item is in quantity

    // emit order event

    // return
    res.status(200).send('ok')
})

app.post('/orders/dispatch', (req, res) => {
    // dispatch order

    // return
    res.status(200).send('ok')
})

app.get('/ping', (req, res) => {
    console.log(req);
    res.status(200).send('PONG')
})

app.listen(port, () => {
    console.log(`Server listening on http://localhost:${port}`)
})