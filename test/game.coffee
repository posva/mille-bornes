Game = require '../src/game'
cards = require '../src/cards'
should = require 'should'
sinon = require 'sinon'
_ = require 'lodash'

describe 'Game', ->
  game = null
  p1 = p2 = null
  beforeEach ->
    game = new Game()
    p1 = game.players[0]
    p2 = game.players[1]
  describe 'Initialization', ->
    it 'creates a deck', ->
      should.exist game.deck
      game.deck.array.should.have.length 101

    it 'creates a discard pile', ->
      game.discard.should.have.length 0

    it 'creates players', ->
      game.players.should.have.length 2

    it 'shuffles the cards', ->
      spy = sinon.spy game.deck, 'shuffle'
      game.start()
      spy.called.should.be.true()

    it 'resets the game', ->
      spy1 = sinon.spy p1, 'reset'
      spy2 = sinon.spy p2, 'reset'
      game.deck.array.should.have.length 101
      game.start()

      spy1.called.should.be.false()
      spy2.called.should.be.false()

      game.deck.array.should.have.length 89
      game.discard.push cards.km100

      game.reset()
      game.deck.array.should.have.length 101
      game.discard.should.be.empty()
      spy1.called.should.be.true()
      spy2.called.should.be.true()

    it 'starts with the right cards in the deck', ->
      _.filter game.deck.array, cards.fuelAttack
      .should.have.length 2
      _.filter game.deck.array, cards.wheelAttack
      .should.have.length 2
      _.filter game.deck.array, cards.accidentAttack
      .should.have.length 2
      _.filter game.deck.array, cards.speedAttack
      .should.have.length 3
      _.filter game.deck.array, cards.lightAttack
      .should.have.length 4

      _.filter game.deck.array, cards.fuelDefense
      .should.have.length 6
      _.filter game.deck.array, cards.wheelDefense
      .should.have.length 6
      _.filter game.deck.array, cards.accidentDefense
      .should.have.length 6
      _.filter game.deck.array, cards.speedDefense
      .should.have.length 6
      _.filter game.deck.array, cards.lightDefense
      .should.have.length 14

      _.filter game.deck.array, cards.fuelShield
      .should.have.length 1
      _.filter game.deck.array, cards.wheelShield
      .should.have.length 1
      _.filter game.deck.array, cards.accidentShield
      .should.have.length 1
      _.filter game.deck.array, cards.lightShield
      .should.have.length 1

      _.filter game.deck.array, cards.km200
      .should.have.length 4
      _.filter game.deck.array, cards.km100
      .should.have.length 12
      _.filter game.deck.array, cards.km75
      .should.have.length 10
      _.filter game.deck.array, cards.km50
      .should.have.length 10
      _.filter game.deck.array, cards.km25
      .should.have.length 10

  describe 'Players', ->
    it 'gives cards to players in the right order', ->
      game.reset()
      game.start()
      for i in [1..6]
        game.deck.add 1, name: 'Player 2'
        game.deck.add 1, name: 'Player 1'

      p1.hand.should.not.containEql name: 'Player 2'
      p2.hand.should.not.containEql name: 'Player 1'

    it 'draws 6 cards for each player', ->
      game.start()
      _.forEach game.players, (player) ->
        player.hand.should.have.length 6

    it 'sets the opponent for players', ->
      game.start()
      p1.opponent.should.be.eql p2
      p2.opponent.should.be.eql p1

    it 'discards player cards', ->
      game.start()
      game.nextTurn()
      game.discard.should.be.empty()
      p1.discard p1.hand[0]
      game.nextTurn()
      should.not.exist p1.discarded
      game.discard.should.have.length 1

    it 'changes current player', ->
      game.start()
      game.nextTurn()
      game.current.should.be.eql 0
      game.nextTurn()
      game.current.should.be.eql 1

    it 'draws a card for the player', ->
      game.start()
      game.nextTurn()
      game.players[1].hand.should.have.length 6
      game.nextTurn()
      game.players[1].hand.should.have.length 7

    it 'cycles the current player', ->
      game.start()
      game.nextTurn()
      game.current.should.eql 0
      game.nextTurn()
      game.current.should.eql 1
      game.nextTurn()
      game.current.should.eql 0

    it 'gets a winner when 1000km', ->
      game.start()
      game.isMatchOver().should.be.false()
      for i in [1..10]
        game.players[0].field.km.push cards.km100
      game.isMatchOver().should.be.true()

    it 'end when there are no more cards', ->
      game.start()
      game.isMatchOver().should.be.false()
      p1.hand.splice 0
      p2.hand.splice 0
      game.isMatchOver().should.be.false()
      game.deck.empty()
      game.isMatchOver().should.be.true()

    it 'gets an extra turn when playing a shield', ->
      game.start()
      game.nextTurn()
      game.current.should.eql 0
      p1.hand.push cards.lightShield
      p1.play cards.lightShield
      game.nextTurn()
      game.current.should.eql 0
      game.nextTurn()
      game.current.should.eql 1
      game.nextTurn()
      game.current.should.eql 0

    it 'draws an extra card on coup fourré', ->
      game.start()
      game.nextTurn()
      p2.hand.should.have.length 6
      p1.hand.should.have.length 7

      p1.hand.push cards.wheelAttack
      p2.hand.push cards.wheelShield

      p2.hand.should.have.length 7
      p1.play cards.wheelAttack
      p2.hand.should.have.length 6
      game.nextTurn()
      p2.hand.should.have.length 8

