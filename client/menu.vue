<style lang="stylus">
.animate
  animation-duration: 1s
  animation-fill-mode: both

.menu
  height: 100vh
  display: flex
  flex-flow: column wrap
  align-items: center
  align-content: center
  justify-content: center

  .logo
    animation-delay: 300ms
    margin-bottom: 2rem

  .entries
    width: 100%
    height: 300px
    display: flex
    flex-flow: column wrap
    align-items: center
    transition: height .3s ease

    stagger = 100ms
    button
      @extend .animate
      animation-name: zoomIn
      animation-duration: .3s
      width: 100%
      max-width: 300px
      transition: opacity .3s ease
      for i in 1..6
        &:nth-of-type({i})
          animation-delay: i * stagger
</style>

<template lang="jade">
.menu(v-cloak)
  img.logo.animated.flipInX(src='/img/logo.jpg')
  .entries
    button.button-primary(v-for='entry in menu', :disabled='entry.disabled', @click='entry.method') {{entry.text}}
</template>

<script lang="coffee">
io = require './socket.io'
_ = require 'lodash'
cards = require '../src/cards'

module.exports =
  props:
    menu: Array
</script>
