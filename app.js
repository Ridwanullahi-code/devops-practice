const http = require('http')

const PORT = process.env.PORT || 3000

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'application/json' })
  res.end(JSON.stringify({
    message: 'Grade Tracker is running!',
    version: '1.0.0',
    environment: process.env.NODE_ENV || 'development'
  }))
})

server.listen(PORT, () => {
  console.log(`Grade Tracker running on port ${PORT}`)
})
