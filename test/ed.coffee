Game = require '../src/game'
Ed = require '../src/ed'
should = require 'should'
sinon = require 'sinon'
_ = require 'lodash'

describe 'Ed AI', ->
  game = null
  p1 = p2 = null
  beforeEach ->
    game = new Game()
    game.players = [new Ed(), new Ed()]
    p1 = game.players[0]
    p2 = game.players[1]

  it 'plays', ->
    game.start()
    game.nextTurn()
    game.players[game.current].hand.should.have.length 7
    game.players[game.current].play()
    game.players[game.current].hand.should.have.length 6

  it 'can end a game', ->
    game.start()
    until game.isMatchOver()
      last = game.current
      game.nextTurn()
      if last isnt game.current and game.current is 0
        console.log '---'
      game.players[game.current].play()
    console.log "Kms: #{game.players[0].kms()} - #{game.players[1].kms()}"

  it 'plays nothing when no cards', ->
    (-> p1.play()).should.not.throw()
