express = require 'express'
app = express()
http = require('http').Server app
io = require('socket.io') http

app.set 'view engine', 'jade'

app.use express.static './public'
app.get '/', (req, res) ->
  res.render 'index'

io.on 'connection', (socket) ->
  console.log 'a user connected'

port = process.env.PORT or 3000
http.listen port, ->
  console.log "Listening on localhost:#{port}"
