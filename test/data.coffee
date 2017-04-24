expect = require('chai').expect
{QueryString, Hash} = require('./sandbox').require '../src/data'


describe 'QueryString', ->
  describe '.stringify()', ->
    it 'should stringify object when object is empty', ->
      expect QueryString.stringify {}
        .to.equal ""

    it 'should stringify object when key in object does not have value', ->
      expect QueryString.stringify test: null
        .to.equal "test="

    it 'should stringify object when key in object does have value', ->
      expect QueryString.stringify hello: "world"
        .to.equal "hello=world"

    it 'should stringify object', ->
      expect QueryString.stringify hello: "world", test: null
        .to.equal "hello=world&test="

  describe '.parse()', ->
    it 'should parse string when string is empty', ->
      expect QueryString.parse ""
        .to.deep.equal {}

    it 'should parse string', ->
      expect QueryString.parse "hello=world&test="
        .to.deep.equal
          hello: "world"
          test: ""


describe 'Hash', ->
  describe '.encode()', ->
    it 'should encode object when object is empty', ->
      expect Hash.encode {}
        .to.equal "#"

    it 'should encode object', ->
      expect Hash.encode hello: "world", github: "buttons"
        .to.equal "#hello=world&github=buttons"

  describe '.decode()', ->
    it 'should decode string when string is empty', ->
      expect Hash.decode ""
        .to.deep.equal {}

    it 'should decode string when string only has a leading #', ->
      expect Hash.decode "#"
        .to.deep.equal {}

    it 'should decode string when string does not have a leading #', ->
      data = hello: "world", github: "buttons"
      expect Hash.decode Hash.encode(data).replace /^#/, ""
        .to.deep.equal data

    it 'should decode string when string does have a leading #', ->
      data = hello: "world", github: "buttons"
      expect Hash.decode Hash.encode data
        .to.deep.equal data

    it 'should decode string when string contains & or =', ->
      data = "hello&world": "goodbye=jack"
      expect Hash.decode Hash.encode data
        .to.deep.equal data
