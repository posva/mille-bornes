Player = require './player'
cards = require './cards'
_ = require 'lodash'

kmToPoints = (km) ->
  switch km
    when 25 then 2
    when 50 then 3
    when 75 then 4
    when 100 then 5
    else 7

class Ed extends Player
  constructor: ->
    super()
    @played = []
    @weight = []

  affectWeight: ->
    @weight.length = @hand.length
    _.fill @weight, 1

    # nullify cards
    _.forEach @hand, (card) =>

    # add score
    _.forEach @hand, (card, i) =>
      # not worth wasting time on it
      return if not @weight[i]
      switch card.type
        when 'defense'
          if @kms() < @opponent.kms()
            @weight[i] = 10
          else
            @weight[i] = 5
        when 'attack'
          if @kms() > @opponent.kms()
            @weight[i] = 10
          else
            @weight[i] = 5
        when 'km'
          @weight[i] = kmToPoints card.name
        else
          @weight[i] = 20
      @weight[i] += 100 if @canPlay card
      return

  play: ->
    return if not @hand.length
    @affectWeight()
    best =
      card: null
      weight: 0
    worst =
      card: null
      weight: 100
    _.forEach @weight, (weight, i) =>
      if weight > 100
        if weight > best.weight
          best.card = @hand[i]
          best.weight = weight
      else if weight < worst.weight
        worst.card = @hand[i]
        worst.weight = weight

    if best.card?
      card = best.card
      console.log "Playing #{card.name} #{card.type}"
      super card
    else
      card = worst.card
      console.log "Discarded #{card.name} #{card.type}"
      @discard card

    if @opponent.played?
      @opponent.played.push card
    @played.push card

    card

module.exports = Ed
