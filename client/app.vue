<style lang="stylus">
@require '../node_modules/animate.css/animate.css'
@require '../node_modules/purecss/build/grids-min.css'
@require '../node_modules/purecss/build/grids-responsive-min.css'
@require './styles/responsive-visibility'

.hand
  background-color: aquamarine
  display: flex
  justify-content: flex-start
  flex-wrap: wrap
  .card
    flex-basis: 50%
    max-width: 104px
    img
      width: 100%

.deck
  background-color: cadetblue

.discard
  background-color: brown

.info
  background-color: coral

.field
  background-color: darkgreen

body
  padding: 0 1rem

disabled-color = #9a9a9a
button:disabled, button:disabled:hover
  background-color: disabled-color
  border-color: disabled-color

button
  margin: .3em 0

</style>

<template lang="jade">
.game.pure-g
  .pure-u-1.pure-u-md-3-4
    .other.pure-u-1.pure-u-md-1-2
      .info.pure-g
        .pure-u-1
          p Other info
      .field.pure-g
        .pure-u-1
          p Other field
    .you.pure-u-1.pure-u-md-1-2
      .info.pure-g
        .pure-u-1
          p Your info
      .field.pure-g
        .pure-u-1
          p Your field
  .pure-u-1-4.hidden-sm
    .hand
      card(:card='cards.km100')
      card(:card='cards.km100')
      card(:card='cards.km100')
      card(:card='cards.km100')
      card(:card='cards.km100')
      card(:card='cards.km100')
      card(:card='cards.km100')
    .deck.pure-g
      .deck.pure-u-1-2
        p Deck
      .discard.pure-u-1-2
        p Discard
  .pure-u-1.visible-sm
    .hand
      card(:card='cards.km100')
      card(:card='cards.km100')
      card(:card='cards.km100')
      card(:card='cards.km100')
      card(:card='cards.km100')
      card(:card='cards.km100')
      card(:card='cards.km100')
component(:is='state', :menu='menu', :config='config', :exit='exit')
</template>

<script lang="coffee">
io = require './socket.io'
cards = require '../src/cards'
_ = require 'lodash'

module.exports =
  data: ->
    cards: cards
    state: 'menu'
    config: null
    waiting: true
    menu: []
    lastMenu: []
  methods:
    exit: ->
      @socket.emit 'exit game'
      @state = 'menu'
      @home()
    home: ->
      @menu = [
        text: 'Single Player'
        method: @singlePlayer
      ,
        text: 'Online'
        method: @online
      ]
    createGame: ->
      @socket.once 'join', =>
        @config.host = true
        @state = 'game'
        @waiting = false
      @socket.emit 'waiting'
      @waiting = true
      @menu = [
        text: 'Waiting for someone'
        method: @createGame
        disabled: @waiting
      ,
        text: 'Back'
        method: =>
          @socket.removeAllListeners 'join'
          @socket.emit 'stop waiting'
          @online()
      ]
    joinGame: ->
      @waiting = true
      @socket.on 'games', (games) =>
        @waiting = false
        console.log games
        @menu = _.map games, (game, i) =>
          text: "Game #{i}"
          method: =>
            @socket.emit 'join', game.id
            console.log 'joining', game.id
        @menu.push
          text: 'Back'
          method: =>
            @socket.removeAllListeners 'games'
            @online()
      @socket.emit 'games'
      @menu = [
        text: 'Retrieving games'
        method: @createGame
        disabled: @waiting
      ,
        text: 'Back'
        method: =>
          @socket.removeAllListeners 'games'
          @online()
      ]
    online: ->
      @waiting = false
      @config =
        players: 2
        bots: 0
      @menu = [
        text: 'Create a game'
        method: @createGame
      ,
        text: 'Join a game'
        method: @joinGame
      ,
        text: 'Back'
        method: @home
      ]
    singlePlayer: ->
      @config =
        players: 1
        bots: 1
      @menu = [
        text: 'Start'
        method: @start
      ,
        text: 'Back'
        method: @home
      ]
    start: ->
      @state = 'game'
  ready: ->
    @socket = io
    @home()
  components:
    game: require './game.vue'
    menu: require './menu.vue'
    card: require './card.vue'
</script>
