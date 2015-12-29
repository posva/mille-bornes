express = require 'express'
app = express()
http = require('http').Server app
io = require('socket.io') http

Game = require './src/game'
Ed = require './src/ed'

app.set 'view engine', 'jade'

app.use express.static './public'
app.get '/', (req, res) ->
  res.render 'index'

io.on 'connection', (socket) ->
  console.log 'a user connected'
  game = new Game()
  pIndex = 0
  game.players[1] = new Ed()

  game.start()
  game.nextTurn()

  player = game.players[pIndex]

  nextTurn = ->
    # XXX only IA
    game.nextTurn()
    while game.current is 1
      if game.isMatchOver()
        socket.emit 'game view', game.renderModel pIndex
        socket.emit 'match over'
        return
      card = game.players[1].play()
      if game.players[1].discarded
        socket.emit 'discard card', card
      else
        socket.emit 'play card', card
      game.nextTurn()
    socket.emit 'game view', game.renderModel pIndex

  socket.emit 'game view', game.renderModel pIndex
  socket.on 'discard card', (card) ->
    if game.current is pIndex
      player.discard card
      nextTurn()
  socket.on 'play card', (card) ->
    if game.current is pIndex and player.canPlay card
      player.play card
      nextTurn()

port = process.env.PORT or 3000
http.listen port, ->
  console.log "Listening on localhost:#{port}"
