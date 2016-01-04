Session = require './session'
_ = require 'lodash'

class SessionManager
  constructor: (@io) ->
    @sessions = {}
    @games = []

  createSession: (socket) ->
    id = socket.conn.id
    socket.on 'disconnect', => delete @sessions[id]
    socket.on 'games', =>
      socket.emit 'games', @games

    socket.on 'waiting', =>
      @games.push
        id: id

    socket.on 'join', (gameId) =>
      _.remove @games, id: gameId
# XXX COME HERE
      @sessions[gameId].join id
      socket.emit 'games', @games

    socket.on 'stop waiting', =>
      _.remove @games, id: id
      socket.emit 'games', @games

    @sessions[id] = new Session socket


module.exports = SessionManager

