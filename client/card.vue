<style lang="stylus">
phone-size = 768px
transition = .3s ease

marginRight()
  margin-right: -70px
  &.tight
    margin-right: -100px
  &:last-of-type
    margin-right: initial
  &:hover
    margin-right: initial

.card-container
  display: flex
  align-items: flex-start
  justify-content: flex-start
  flex-wrap: wrap
  background-color: #d8d8d8
  border-radius: 8px
  margin: 5px 0px
  overflow: hidden

  .card
    display: flex
    align-items: center
    justify-content: center
    flex-wrap: wrap
    z-index: 1
    padding: 3px
    img
      width: 100%
    &.muted
      img
        filter: grayscale(1)
    margin: 1px 3px
    width: 104px
    min-height: 144px

    &.stack
      transition: margin-right transition, background-color transition
      border-radius: 3px
      @media screen and (max-width: phone-size)
        marginRight()
      &.force
        marginRight()
      &:hover
        &.playable
          cursor: pointer
        &.muted
          &.playable
            background-color: tomato
          img
            filter: grayscale(.75)
        &.playable:not(.muted)
          background-color: seagreen

    span
      display: block
      font-weight: bolder
</style>

<template lang="jade">
.card(:class='{muted: !visible}')
  div(v-if='card.type')
    img(:src='url')
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
