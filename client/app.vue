<style lang="stylus">
@require '../node_modules/animate.css/animate.css'
body
  padding: 0 1rem

</style>

<template lang="jade">
component(:is='state', :menu='menu', :config='config', :exit='exit')
</template>

<script lang="coffee">
io = require './socket.io'

module.exports =
  data: ->
    state: 'menu'
    config: null
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
        method: @singlePlayer
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
</script>
