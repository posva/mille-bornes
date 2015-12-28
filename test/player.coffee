Player = require '../src/player'
cards = require '../src/cards'
should = require 'should'
_ = require 'lodash'

canDefend = (p1, defense, shield, attack) ->
  it 'cannot play on empty stack', ->
    p1.canPlay defense
    .should.be.false()
  it "can play on #{defense.name} attack", ->
    p1.field.attack.push attack
    p1.canPlay defense
    .should.be.true()
  it 'cannot play on same', ->
    p1.field.attack.push defense
    p1.canPlay defense
    .should.be.false()
  it 'cannot play on other attacks', ->
    p1.field.attack.push cards.lightAttack
    p1.canPlay defense
    .should.be.false()
  it 'cannot play if he has a shield', ->
    p1.field.shield.push shield
    p1.canPlay defense
    .should.be.false()

canAttack = (p1, p2, shield, attack) ->
  it 'cannot play on empty stack', ->
    p1.canPlay attack
    .should.be.false()
  it "can play on green light", ->
    p2.field.attack.push cards.lightDefense
    p1.canPlay attack
    .should.be.true()
  it 'cannot play on same', ->
    p2.field.attack.push attack
    p1.canPlay attack
    .should.be.false()
  it 'cannot play on attacks', ->
    p2.field.attack.push cards.lightAttack
    p1.canPlay attack
    .should.be.false()
  it 'cannot play if he has a shield', ->
    p2.field.shield.push shield
    p1.canPlay attack
    .should.be.false()
  it 'can play on defenses with light shield', ->
    p2.field.shield.push cards.lightShield
    p2.field.attack.push cards.wheelDefense
    p1.canPlay attack
    .should.be.true()
  it 'can play on empty pile with light shield', ->
    p2.field.shield.push cards.lightShield
    p1.canPlay attack
    .should.be.true()

describe 'player', ->
  p1 = p2 = null
  green =
    name: 'light'
    name: 'light'

  beforeEach ->
    p1 = new Player()
  describe 'Initialization', ->
    it 'receives cards', ->
      p1.hand.should.be.empty()
      p1.give name: 'hello'
      p1.hand.should.not.be.empty()

    it 'resets itself', ->
      p1.hand.should.be.empty()
      p1.field.shield.should.be.empty()
      p1.field.km.should.be.empty()
      p1.field.attack.should.be.empty()
      p1.field.speed.should.be.empty()
      should.not.exist p1.discarded

      p1.field.shield.push name: 'hello'
      p1.field.km.push name: 'hello'
      p1.field.attack.push name: 'hello'
      p1.field.speed.push name: 'hello'
      p1.give name: 'hello'

      p1.discarded = name: 'hello'

      p1.reset()
      p1.hand.should.be.empty()
      p1.field.shield.should.be.empty()
      p1.field.km.should.be.empty()
      p1.field.attack.should.be.empty()
      p1.field.speed.should.be.empty()
      should.not.exist p1.discarded

  describe 'Can I play this card', ->
    beforeEach ->
      p2 = new Player()
      p1.opponent = p2
      p2.opponent = p1

      _.forOwn cards, (card) ->
        p1.hand.push card
        p2.hand.push card

    it 'cannot play a card that is not in his hand', ->
      p1.hand.splice 0
      p1.canPlay cards.lightDefense
      .should.be.false()

    describe 'green light defense', ->
      it 'can play on empty stack', ->
        p1.canPlay cards.lightDefense
        .should.be.true()
      it 'can play on red light', ->
        p1.field.attack.push cards.lightAttack
        p1.canPlay cards.lightDefense
        .should.be.true()
      it 'cannot play on same', ->
        p1.field.attack.push cards.lightDefense
        p1.canPlay cards.lightDefense
        .should.be.false()
      it 'cannot play on others attacks', ->
        p1.field.attack.push cards.wheelAttack
        p1.canPlay cards.lightDefense
        .should.be.false()
      it 'cannot play if it has a shield', ->
        p1.field.shield.push cards.lightShield
        p1.canPlay cards.lightDefense
        .should.be.false()

    describe 'fuel defense', ->
      p = new Player()
      _.forOwn cards, (card) ->
        p.hand.push card
      canDefend p, cards.fuelDefense, cards.fuelShield, cards.fuelAttack

    describe 'wheel defense', ->
      p = new Player()
      _.forOwn cards, (card) ->
        p.hand.push card
      canDefend p, cards.wheelDefense, cards.wheelShield, cards.wheelAttack

    describe 'accident defense', ->
      p = new Player()
      _.forOwn cards, (card) ->
        p.hand.push card
      canDefend p, cards.accidentDefense, cards.accidentShield, cards.accidentAttack

    describe 'speed defense', ->
      it 'cannot play on empty stack', ->
        p1.canPlay cards.speedDefense
        .should.be.false()
      it 'can play on low speed', ->
        p1.field.speed.push cards.speedAttack
        p1.canPlay cards.speedDefense
        .should.be.true()
      it 'cannot play on same', ->
        p1.field.speed.push cards.speedDefense
        p1.canPlay cards.speedDefense
        .should.be.false()
      it 'cannot play if it has a shield', ->
        p1.field.shield.push cards.lightShield
        p1.canPlay cards.speedDefense
        .should.be.false()

    describe 'red light attack', ->
      it 'cannot play on empty stack', ->
        p1.canPlay cards.lightAttack
        .should.be.false()
      it 'can play on green light', ->
        p2.field.attack.push cards.lightDefense
        p1.canPlay cards.lightAttack
        .should.be.true()
      it 'cannot play on same', ->
        p2.field.attack.push cards.lightAttack
        p1.canPlay cards.lightAttack
        .should.be.false()
      it 'cannot play on others attacks', ->
        p2.field.attack.push cards.wheelAttack
        p1.canPlay cards.lightAttack
        .should.be.false()
      it 'cannot play if it has a shield', ->
        p2.field.shield.push cards.lightShield
        p1.canPlay cards.lightAttack
        .should.be.false()

    describe 'fuel attack', ->
      pp1 = new Player()
      pp2 = new Player()
      pp1.opponent = pp2
      pp2.opponent = pp1
      _.forOwn cards, (card) ->
        pp1.hand.push card
        pp2.hand.push card
      canAttack pp1, pp2, cards.fuelShield, cards.fuelAttack

    describe 'wheel attack', ->
      pp1 = new Player()
      pp2 = new Player()
      pp1.opponent = pp2
      pp2.opponent = pp1
      _.forOwn cards, (card) ->
        pp1.hand.push card
        pp2.hand.push card
      canAttack pp1, pp2, cards.wheelShield, cards.wheelAttack

    describe 'accident attack', ->
      pp1 = new Player()
      pp2 = new Player()
      pp1.opponent = pp2
      pp2.opponent = pp1
      _.forOwn cards, (card) ->
        pp1.hand.push card
        pp2.hand.push card
      canAttack pp1, pp2, cards.accidentShield, cards.accidentAttack

    describe 'Km', ->
      it 'cannot advance without green light', ->
        p1.canPlay cards.km100
        .should.be.false()
      it 'cannot advance with attack', ->
        p1.field.attack.push cards.wheelAttack
        p1.canPlay cards.km100
        .should.be.false()
      it 'cannot advance too much if speed limited', ->
        p1.field.attack.push cards.lightDefense
        p1.field.speed.push cards.speedAttack
        p1.canPlay cards.km100
        .should.be.false()
        p1.canPlay cards.km200
        .should.be.false()
        p1.canPlay cards.km75
        .should.be.false()
        p1.canPlay cards.km50
        .should.be.true()
        p1.canPlay cards.km25
        .should.be.true()
      it 'can advance with green light', ->
        p1.field.attack.push cards.lightDefense
        p1.canPlay cards.km100
        .should.be.true()
      it 'can advance with light shield', ->
        p1.field.shield.push cards.lightShield
        p1.canPlay cards.km100
        .should.be.true()
      it 'can advance with light shield and speed limit', ->
        p1.field.shield.push cards.lightShield
        p1.field.speed.push cards.speedAttack
        p1.canPlay cards.km100
        .should.be.true()
      it 'can advance with light shield and defense', ->
        p1.field.shield.push cards.lightShield
        p1.field.attack.push cards.wheelDefense
        p1.canPlay cards.km100
        .should.be.true()

      it 'cannot play more than 2 200km', ->
        p1.field.attack.push cards.lightDefense
        p1.field.km.push cards.km200
        p1.canPlay cards.km200
        .should.be.true()
        p1.field.km.push cards.km200
        p1.canPlay cards.km200
        .should.be.false()

      it 'cannot advance beyond 1000km', ->
        p1.field.attack.push cards.lightDefense
        for i in [1..9]
          p1.field.km.push cards.km100
        p1.field.km.push cards.km75

        p1.canPlay cards.km100
        .should.be.false()
        p1.canPlay cards.km200
        .should.be.false()
        p1.canPlay cards.km75
        .should.be.false()
        p1.canPlay cards.km50
        .should.be.false()

        p1.canPlay cards.km25
        .should.be.true()

    describe 'Shields', ->
      it 'can always play shields', ->
        p1.canPlay cards.lightShield
        p1.canPlay cards.wheelShield
        p1.canPlay cards.accidentShield
        p1.canPlay cards.fuelShield

  describe 'Card playing', ->
    beforeEach ->
      p2 = new Player()
      p1.opponent = p2
      p2.opponent = p1

      _.forOwn cards, (card) ->
        p1.hand.push card
        p2.hand.push card

    it 'removes the card from the hand', ->
      p1.hand.should.containEql cards.lightDefense
      p1.play cards.lightDefense
      p1.hand.should.not.containEql cards.lightDefense

    it 'only removes one card', ->
      p1.hand.push cards.lightDefense
      p1.play cards.lightDefense
      p1.hand.should.containEql cards.lightDefense
      p1.hand.should.have.length 19
      p1.play cards.lightDefense
      p1.hand.should.have.length 18

    it 'plays nothing if not present', ->
      p1.field.attack.should.have.length 0
      p1.play cards.lightDefense
      p1.hand.should.not.containEql cards.lightDefense
      p1.hand.should.have.length 18
      p1.play cards.lightDefense
      p1.hand.should.not.containEql cards.lightDefense
      p1.hand.should.have.length 18
      p1.field.attack.should.have.length 1

    it 'adds km cards to its field', ->
      p1.field.km.should.be.empty()
      p1.field.km.should.containEql p1.play cards.km100

    it 'adds fuel, wheel, light and accidents cards to its field', ->
      p2.field.attack.should.containEql p1.play cards.lightAttack
      p2.field.attack.should.containEql p1.play cards.fuelAttack
      p2.field.attack.should.containEql p1.play cards.accidentAttack
      p2.field.attack.should.containEql p1.play cards.wheelAttack
      p1.field.attack.should.containEql p1.play cards.lightDefense
      p1.field.attack.should.containEql p1.play cards.fuelDefense
      p1.field.attack.should.containEql p1.play cards.accidentDefense
      p1.field.attack.should.containEql p1.play cards.wheelDefense

    it 'adds speed to its fields', ->
      p1.field.speed.should.containEql p1.play cards.speedDefense
      p2.field.speed.should.containEql p1.play cards.speedAttack

    it 'adds shields to its fields', ->
      p1.field.shield.should.containEql p1.play cards.lightShield

    it 'discards a card only if he has it', ->
      should.not.exist p1.discarded
      p1.hand.should.not.containEql p1.discard cards.lightAttack
      p1.discarded.should.be.eql cards.lightAttack

    it 'discarding decreases hand size', ->
      p1.hand.should.have.length 19
      p1.discard cards.lightAttack
      p1.hand.should.have.length 18

