cards = require './cards'
_ = require 'lodash'

class Player
  constructor: ->
    @discarded = null
    @opponent = null
    @hand = []
    @coupFourres = []
    @playedShield = false
    @playedCoupFourre = false
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
    @playedShield = false
    @coupFourres.splice 0
    @playedCoupFourre = false
    undefined

  give: (card) -> @hand.push(card) if card?

  defend: (card) ->
    name = if card.name is 'speed' then 'light' else card.name
    shieldIndex = _.findIndex @hand, name: name, type: 'shield'
    return false if shieldIndex < 0
    shield = @hand.splice(shieldIndex, 1)[0]
    @field.shield.push shield
    @coupFourres.push shield
    @playedCoupFourre = true

  isLastAttackNullified: ->
    lastAttack = @field.attack[@field.attack.length - 1]
    not lastAttack? or lastAttack.type is 'defense' or @hasShield lastAttack.name


  canPlayGreen: ->
    lastAttack = @field.attack[@field.attack.length - 1]
    not @hasShield('light') and (@isLastAttackNullified() or
    (lastAttack.type is 'attack' and lastAttack.name is 'light')) and
    (not lastAttack? or lastAttack.type isnt 'defense' or lastAttack.name isnt 'light')

  canPlayKm: ->
    lastAttack = @field.attack[@field.attack.length - 1]
    (@hasShield('light') or (lastAttack? and lastAttack.type is 'defense' and
    lastAttack.name is 'light')) and @isLastAttackNullified()

  canPlay: (card) ->
    return false if not _.find @hand, card
    lastAttack = @field.attack[@field.attack.length - 1]
    lastSpeed = @field.speed[@field.speed.length - 1]
    switch card.type
      when 'defense'
        if card.name is 'light'
          @canPlayGreen()
        else if card.name isnt 'speed'
          lastAttack? and
          lastAttack.type is 'attack' and lastAttack.name is card.name and
          not @hasShield card.name
        else
          lastSpeed? and lastSpeed.type is 'attack' and not @hasShield 'light'
      when 'attack'
        opLastAttack = @opponent.field.attack[@opponent.field.attack.length - 1]
        opLastSpeed = @opponent.field.speed[@opponent.field.speed.length - 1]
        if card.name is 'light'
          opLastAttack? and opLastAttack.name is 'light' and
          opLastAttack.type is 'defense' and not @opponent.hasShield 'light'
        else if card.name isnt 'speed'
          @opponent.canPlayKm() and not @opponent.hasShield card.name
        else
          (not opLastSpeed? or opLastSpeed.type is 'defense') and
          not @opponent.hasShield 'light'
      when 'km'
        if card.name is 200 and _.filter(@field.km, name: 200).length is 2 or
        card.name + @kms() > 1000
          return false
        @canPlayKm() and (@hasShield('light') or not lastSpeed? or
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
