_ = require 'lodash'

class Server

  constructor: ->
    @events = {}

  on: (event, callback) ->
    @events[event] ?= []
    @events[event].push callback

  simulate: (event, data) ->
    if event of @events
      _.forEach @events[event], (callback) ->
        callback data

module.exports = Server
