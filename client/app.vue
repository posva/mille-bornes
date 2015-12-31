<style lang="stylus">
</style>

<template lang="jade">
p(v-show='over')
  strong Game is over!
p Deck has {{game.deck}}. Discard has {{game.discard.length}}
p Your opponent has {{game.other.hand}} cards in hand
p Opponent {{log[0]}}
div
  .card-container
    card.force.stack(v-for='shield in game.other.field.shield', :card='shield')
    card(:card='opLastAttack')
    card(:card='opLastSpeed')
    card.force.tight.stack(v-for='km in game.other.field.km', :card='km')
  p Km: {{opKms}}
div
  .card-container
    card.force.stack(v-for='shield in game.me.field.shield', :card='shield')
    card(:card='meLastAttack')
    card(:card='meLastSpeed')
    card.force.stack.tight(v-for='km in game.me.field.km', :card='km')
  p Km: {{meKms}}
  .card-container
    card.stack.playable(v-ref:card, v-for='card in game.me.hand', :card='card', @click='play($index)')
</template>

<script lang="coffee">
io = require 'socket.io-client'
_ = require 'lodash'
cards = require '../src/cards'

module.exports =
  data: ->
    cards: cards
    over: false
    log: []
    game:
      deck: 0
      discard: []
      me:
        hand: []
        field:
          attack: []
          shield: []
          speed: []
          km: []
      other:
        hand: 0
        field:
          attack: []
          shield: []
          speed: []
          km: []
  computed:
    meKms: -> _.reduce @game.me.field.km, (total, card) ->
      total + card.name
    , 0
    meLastSpeed: ->
      @game.me.field.speed[@game.me.field.speed.length - 1] or
      name: 'Speed'
      type: null
    meLastAttack: ->
      @game.me.field.attack[@game.me.field.attack.length - 1] or
      name: 'Attack / Defense'
      type: null
    opKms: ->
      _.reduce(@game.other.field.km, (total, card) ->
        total + card.name
      , 0)
    opLastSpeed: ->
      @game.other.field.speed[@game.other.field.speed.length - 1] or
      name: 'Speed'
      type: null
    opLastAttack: ->
      @game.other.field.attack[@game.other.field.attack.length - 1] or
      name: 'Attack / Defense'
      type: null
  methods:
    play: (index) ->
      if not @over
        card = @game.me.hand[index]
        style = window.getComputedStyle @$refs.card[index].$el
        if 'marginRight' not of style
          margin = -100
        margin = parseInt style.marginRight, 10
        if margin > -20
          if card.playable
              @socket.emit 'play card', name: card.name, type: card.type
          else
            @socket.emit 'discard card', name: card.name, type: card.type
  ready: ->
    @socket = io()
    @socket.on 'game view', (game) => @game = game
    @socket.on 'discard card', (card) =>
      @log.unshift "discarded #{card.name} #{card.type}"
    @socket.on 'play card', (card) =>
      @log.unshift "played #{card.name} #{card.type}"
    @socket.on 'match over', =>
      @over = true
  components:
    card: require './card.vue'
</script>
