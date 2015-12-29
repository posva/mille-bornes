<style lang="stylus">
</style>

<template lang="jade">
p(v-show='over')
  strong Game is over!
p Deck has {{game.deck}}. Discard has {{game.discard.length}}
p Your opponent has {{game.other.hand}} cards in hand
p Opponent {{log[0]}}
div
  p Shields
  ul
    li(v-for='shield in game.other.shield') {{shield.name}}
  p Attacks: {{opLastAttack | json}}
  p Speed: {{opLastSpeed | json}}
  p Km: {{opKms}}
  ul
    li(v-for='card in game.other.field.km') {{card.name}}
div
  p Shields
  ul
    li(v-for='shield in game.me.shield') {{shield.name}}
  p Attacks: {{meLastAttack | json}}
  p Speed: {{meLastSpeed | json}}
  p Km: {{meKms}}
  ul
    li(v-for='card in game.me.field.km') {{card.name}}
  ul
    li(v-for='card in game.me.hand')
      span {{card | json}}
      button(@click='play(card)', :disabled='!card.playable || over') Play
      button(@click='discard(card)', :disabled='over') Discard
</template>

<script lang="coffee">
io = require 'socket.io-client'
_ = require 'lodash'

module.exports =
  data: ->
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
      @game.me.field.speed[@game.me.field.speed.length - 1]
    meLastAttack: ->
      @game.me.field.attack[@game.me.field.attack.length - 1]
    opKms: -> _.reduce @game.other.field.km, (total, card) ->
      total + card.name
    , 0
    opLastSpeed: ->
      @game.other.field.speed[@game.other.field.speed.length - 1]
    opLastAttack: ->
      @game.other.field.attack[@game.other.field.attack.length - 1]
  methods:
    discard: (card) ->
      console.log 'Discarded', card
      @socket.emit 'discard card', name: card.name, type: card.type
    play: (card) ->
      console.log 'Played', card
      @socket.emit 'play card', name: card.name, type: card.type
  ready: ->
    @socket = io()
    @socket.on 'game view', (game) =>
      console.log game
      @game = game
    @socket.on 'discard card', (card) =>
      @log.unshift "discarded #{card.name} #{card.type}"
    @socket.on 'play card', (card) =>
      @log.unshift "played #{card.name} #{card.type}"
    @socket.on 'match over', =>
      @over = true
</script>
