Server = require './utils/socket-mock'
should = require 'should'
sinon = require 'sinon'
_ = require 'lodash'

describe.only 'Socket.io Mock', ->
  io = null
  beforeEach ->
    io = new Server()
  describe 'Listening', ->
    spy = null
    beforeEach ->
      spy = sinon.spy -> null

    it 'calls callbacks', ->
      io.on 'test', spy
      spy.called.should.be.false()
      io.simulate 'test'
      spy.callCount.should.be.eql 1

    it 'can have multiple callbacks', ->
      spy2 = sinon.spy -> null
      io.on 'test', spy
      io.on 'test', spy2
      io.simulate 'test'
      spy.callCount.should.be.eql 1
      spy2.callCount.should.be.eql 1

    it 'calls the cb multiple times with on', ->
      io.on 'test', spy
      for i in [1..5]
        io.simulate 'test'
        spy.callCount.should.be.eql i

    it 'calls the cb with arguments', ->
      io.on 'test', spy
      io.simulate 'test', 'data'
      spy.calledWith 'data'
      .should.be.true()
