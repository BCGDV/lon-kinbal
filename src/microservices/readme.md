## Microservices

- 3 exemplar microservices that are built using Javascript (Node), Go and Python that . These microservices have the following characteristics and components:
    - Health check endpoints
    - Example persistence layer interactions
    - Example events layer interactions
    - Containerised using Docker
    - Contain their own deployment configuration files that provision services, deployments and ingresses

- Each exemplar microservice also provisions it's own dedicated and isolated persistence layer - a PostgreSQL RDS instance.

### Service 1

**Technology** - Javascript (Node)

**Architecture** - N/A (basic)

**Endpoints** 

- **/service/info (GET)**

Functionality: Returns information regarding the service.

Parameters: N/A.

Response 200:

```
{
    "service" : "service-1",
    "res" :: TIMESTAMP
}
```

- **/ping (GET)**

Functionality: Health check endpoint

Parameters: N/A.

Response 200:

```
{
    "service" : "service-1",
    "res" :: "PONG"
}
```

- **/orders/get (GET)**

Functionality: Demonstrates persistence layer functionality by connecting to the microservice database and fetching list of orders.

Parameters: N/A.

Response 200:

```
{
    "orders" : ORDERS
}
```

- **/orders/create (POST)**

Functionality: Demonstrates persistence functionality by connecting to the microservice database and creating a new order. Demonstrates events layer functionality by firing off order created event into event-bus.

Parameters: N/A.

Body: 

```
{
    "item": "Pork Pies",
    "quantity": 1,
    "userid": "fq3dq3t-x3T4QVB-qcr4t3byec-5y3tc4w"
}
```

Response 200:

```
{
    "res" :: ORDER
}
```

### Service 2

**Technology** - Go

**Architecture** - N/A (basic)

**Endpoints**

- **/ping (GET)**

Functionality: Health check endpoint 

Parameters: N/A

Response 200:

```
{
    "res" :: "PONG"
}
```

- **/service/info (GET)**

Functionality: Returns information regarding the service.

Parameters: N/A.

Response 200:

```
{
    "service" : "service-2",
    "res" :: TIMESTAMP
}
```

### Service 3

**Technology** - Flask (Python)

**Architecture** - N/A (basic)

**Endpoints** 

- **/ping (GET)**

Functionality: Health check endpoint 

Parameters: N/A

Response 200:

```
{
    "service": 'service-3',
    "res": 'PONG'
}
```

- **/service/info (GET)**

Functionality: Returns information regarding the service.

Parameters: N/A.

Response 200:

```
{
    "service" : "service-3",
    "res" :: TIMESTAMP
}
```