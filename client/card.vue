<style lang="stylus">
img.not-playable
  filter: grayscale(.9) opacity(.8)
  max-width: 100%
.card-container, .card
  display: flex
  align-items: center
  justify-content: center
  flex-wrap: wrap
.card-container .card
  margin: 5px
  padding: 10px
  min-width: 208px
  min-height: 288px
  background-color: #d8d8d8
  border-radius: 8px
  span
    display: block
    font-weight: bolder
</style>

<template lang="jade">
.card
  div(v-if='card.type')
    img(:class='{"not-playable": !visible}', :src='url')
    slot
  span(v-else) {{card.name}}
</template>

<script lang="coffee">
module.exports =
  data: ->
  props:
    card: Object
    default:
      playable: true
      type: 'card'
      name: 'back'
  computed:
    url: ->  "/img/#{@card.type}-#{@card.name}.jpg"
    visible: -> not @card.playable? or @card.playable
</script>
