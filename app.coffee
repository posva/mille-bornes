express = require 'express'
app = express()
http = require('http').Server app
io = require('socket.io') http
_ = require 'lodash'

SessionManager = require './src/session-manager'

app.set 'view engine', 'jade'

app.use express.static './public'
app.get '/', (req, res) ->
  res.render 'index'

sessionManager = new SessionManager io
io.on 'connection', (socket) ->
  sessionManager.createSession socket

port = process.env.PORT or 3000
http.listen port, ->
  console.log "Listening on localhost:#{port}"
