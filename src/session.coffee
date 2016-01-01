Game = require './game'
Ed = require './ed'

class Session
  constructor: (socket) ->
    @socket = socket
    @game = new Game()
    console.log 'Session started'

    @socket.on 'disconnect', =>
      console.log 'Session Disconnected'

    @waitForGame()

  waitForGame: ->
    @socket.once 'new game', (config) =>
      @game.reset config

      @socket.once 'exit game', (config) =>
        @socket.removeAllListeners 'play card'
        @socket.removeAllListeners 'discard card'
        @socket.removeAllListeners 'new match'
        @waitForGame()

      # players
      if config.bots > 0
        @game.players[1] = new Ed()
      @pIndex = 0

      @game.start()
      @game.nextTurn()

      @player = @game.players[@pIndex]

      nextTurn = =>
        @game.nextTurn()
        while @game.current is 1
          if @game.isMatchOver()
            @socket.emit 'game view', @game.renderModel @pIndex
            @socket.emit 'match over'
            return
          card = @game.players[1].play()
          if @game.players[1].discarded
            @socket.emit 'discard card', card
          else
            @socket.emit 'play card', card
          if not @game.isMatchOver()
            @game.nextTurn()

        if @game.isMatchOver()
          @socket.emit 'match over'
        @socket.emit 'game view', @game.renderModel @pIndex

      @socket.on 'discard card', (card) =>
        if @game.current is @pIndex
          @player.discard card
          nextTurn()

      @socket.on 'play card', (card) =>
        if @game.current is @pIndex and @player.canPlay card
          @player.play card
          nextTurn()

      @socket.on 'new match', =>
        @game.reset()
        @game.start()
        @game.nextTurn()
        @socket.emit 'game view', @game.renderModel @pIndex

      @socket.emit 'game view', @game.renderModel @pIndex

module.exports = Session
