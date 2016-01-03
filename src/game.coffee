Deck = require './deck'
Player = require './player'
cards = require './cards'
_ = require 'lodash'

class Game
  constructor: ->
    @deck = new Deck()
    @players = []
    @discard = []
    @current = -1
    @kms = 1000

    @players.push new Player()
    @players.push new Player()

    @init()

  reset: ->
    @deck.empty()
    _.forEach @players, (player) -> player.reset()
    @current = -1
    @discard.splice 0
    @init()

  start: ->
    @deck.shuffle()
    for i in [1..6]
      _.forEach @players, (player) => player.give @deck.draw()
    @players[0].opponent = @players[1]
    @players[1].opponent = @players[0]

  renderModel: (player) ->
    p = @players[player]
    o = @players[Number not player]
    hand = _.map p.hand, (card) ->
      card = _.clone card
      card.playable = p.canPlay card
      card
    me:
      hand: hand
      field: p.field
    other:
      field: o.field
      hand: o.hand.length
    deck: @deck.array.length
    discard: @discard

  init: ->
    # Attacks
    @deck.add 2, cards.fuelAttack
    @deck.add 2, cards.wheelAttack
    @deck.add 2, cards.accidentAttack
    @deck.add 3, cards.speedAttack
    @deck.add 4, cards.lightAttack

    # Defenses
    @deck.add 6, cards.fuelDefense
    @deck.add 6, cards.wheelDefense
    @deck.add 6, cards.accidentDefense
    @deck.add 6, cards.speedDefense
    @deck.add 14, cards.lightDefense

    # Shields
    @deck.add 1, cards.fuelShield
    @deck.add 1, cards.wheelShield
    @deck.add 1, cards.accidentShield
    @deck.add 1, cards.lightShield

    # Km
    @deck.add 4, cards.km200
    @deck.add 12, cards.km100
    @deck.add 10, cards.km75
    @deck.add 10, cards.km50
    @deck.add 10, cards.km25

  nextTurn: ->
    if @current isnt -1
      d = @players[@current].discarded
      @discard.push(d) if d?
      @players[@current].discarded = null
      if @players[@current].playedShield
        @players[@current].playedShield = false
        --@current
    if ++@current >= @players.length
      @current = 0

    if @players[@current].playedCoupFourre
      @players[@current].give @deck.draw()
      @players[@current].playedCoupFourre = false

    @players[@current].give @deck.draw()

  isMatchOver: ->
    if @deck.array.length or _.some(@players, (player) -> player.hand.length)
      _.some @players, (player) => player.kms() is @kms
    else
      true

module.exports = Game
