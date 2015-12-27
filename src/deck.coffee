_ = require 'lodash'

class Deck
  constructor: ->
    @array = []

  empty: -> @array.splice 0
  add: (amount, card) ->
    start = @array.length
    @array.length += amount
    _.fill @array, card, start
  draw: -> @array.pop()
  shuffle: ->
    i = @array.length
    while i > 0
      j = Math.floor Math.random() * i
      x = @array[--i]
      @array[i] = @array[j]
      @array[j] = x

module.exports = Deck
