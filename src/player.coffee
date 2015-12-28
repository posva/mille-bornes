cards = require './cards'
_ = require 'lodash'

class Player
  constructor: ->
    @discarded = null
    @opponent = null
    @hand = []
    @coupFourres = []
    @playedShield = false
    @field =
      shield: []
      km: []
      attack: []
      speed: []

  hasShield: (shield) -> _.some @field.shield, name: shield

  reset: ->
    @hand.splice 0
    @discarded = null
    @field.shield.splice 0
    @field.km.splice 0
    @field.attack.splice 0
    @field.speed.splice 0

  give: (card) -> @hand.push(card) if card?

  defend: (card) ->
    shieldIndex = _.findIndex @hand, name: card.name, type: 'shield'
    return false if shieldIndex < 0
    shield = @hand.splice(shieldIndex, 1)[0]
    @field.shield.push shield
    @coupFourres.push shield

  canPlay: (card) ->
    return false if not _.find @hand, card
    lastAttack = @field.attack[@field.attack.length - 1]
    lastSpeed = @field.speed[@field.speed.length - 1]
    switch card.type
      when 'defense'
        if card.name is 'light'
          (not lastAttack? or
            (lastAttack.type is 'attack' and lastAttack.name is 'light')
          ) and not @hasShield 'light'
        else if card.name isnt 'speed'
          lastAttack? and
          lastAttack.type is 'attack' and lastAttack.name is card.name and
          not @hasShield card.name
        else
          lastSpeed? and lastSpeed.type is 'attack' and not @hasShield 'speed'
      when 'attack'
        opLastAttack = @opponent.field.attack[@opponent.field.attack.length - 1]
        opLastSpeed = @opponent.field.speed[@opponent.field.speed.length - 1]
        if card.name is 'light'
          opLastAttack? and opLastAttack.name is 'light' and
          opLastAttack.type is 'defense' and not @opponent.hasShield 'light'
        else if card.name isnt 'speed'
          if @opponent.hasShield 'light'
            not opLastAttack? or opLastAttack.type is 'defense'
          else
            opLastAttack? and opLastAttack.type is 'defense' and
              opLastAttack.name is 'light' and not @opponent.hasShield card.name
        else
          (not opLastSpeed? or opLastSpeed.type is 'defense') and
          not @opponent.hasShield 'light'
      when 'km'
        if card.name is 200 and _.filter(@field.km, name: 200).length is 2 or
        card.name + @kms() > 1000
          return false
        if @hasShield 'light'
          not lastAttack? or lastAttack.name is 'light' or
          lastAttack.type is 'defense'
        else
          lastAttack? and lastAttack.type is 'defense' and
          lastAttack.name is 'light' and (not lastSpeed? or
          lastSpeed.type is 'defense' or card.name <= 50)
      when 'shield'
        true
      else null

  play: (card) ->
    index = _.findIndex @hand, card
    return if index < 0
    switch card.type
      when 'attack', 'defense'
        if card.name is 'speed'
          field = 'speed'
        else
          field = 'attack'
      else field = card.type
    if field of @field
      if card.type is 'attack'
        if not @opponent.defend card
          @opponent.field[field].push card
        else
          @discarded = card
      else
        @field[field].push card
      @hand.splice index, 1
      if card.type is 'shield'
        @playedShield = true
      card

  discard: (card) ->
    index = _.findIndex @hand, card
    return if index < 0
    @discarded = @hand.splice(index, 1)[0]

  kms: ->
    _.reduce @field.km, (total, km) ->
      total + km.name
    , 0

module.exports = Player
