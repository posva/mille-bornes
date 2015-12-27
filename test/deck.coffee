Deck = require '../src/deck'
should = require 'should'
_ = require 'lodash'

describe 'Deck', ->
  deck = null
  describe 'Initialization', ->
    beforeEach ->
      deck = new Deck()

    it 'is empty at creation', ->
      deck.array.should.be.empty()

    it 'draws nothing when empty', ->
      should.not.exist deck.draw()

    it 'can receive a card', ->
      deck.add 1, name: 'hello'
      deck.array.should.have.length 1

    it 'can receive multiple cards', ->
      deck.add 2, name: 'hello'
      deck.array.should.have.length 2
      deck.add 4, name: 'hello'
      deck.array.should.have.length 6

  describe 'Usage', ->
    beforeEach ->
      deck = new Deck()
      deck.add 1, name: 'Fourth'
      deck.add 2, name: 'Second'
      deck.add 1, name: 'First'

    it 'draws the first card', ->
      card = deck.draw()
      should.exist card
      card.should.have.property 'name', 'First'

    it 'removes the cards from the array', ->
      deck.draw()
      deck.array.should.have.length 3

    it 'shuffles the deck', ->
      # make it bigger so the change of getting the same array and thefore
      # failing the test is lower
      deck.add 100, name: 'others'
      clone = _.clone deck.array, true
      deck.shuffle()
      deck.array.should.not.deepEqual clone

    it 'can be emptied', ->
      deck.array.should.not.be.empty()
      deck.empty()
      deck.array.should.be.empty()
