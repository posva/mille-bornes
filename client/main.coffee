io = require 'socket.io-client'
socket = io()

socket.on 'game view', (game) ->
  console.log game
