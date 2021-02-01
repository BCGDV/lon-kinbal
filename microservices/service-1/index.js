const express = require('express')
const AWS = require("aws-sdk")
const eventbridge = new AWS.EventBridge()

const app = express()
const port = 8080

app.get('/', (req, res) => {
    console.log(`${req.url} ${req.method} ${Math.round((new Date()).getTime() / 1000)}`)
    res.status(200).send({
        service: 'service-1',
        res: `Request received on ${Math.round((new Date()).getTime() / 1000)}`
    })
})

app.get('/ping', (req, res) => {
    console.log(`${req.url} ${req.method}`)
    res.status(200).send({
        service: 'service-1',
        res: 'PONG'
    })
})

app.listen(port, () => {
    console.log(`Server listening on http://localhost:${port}`)
})