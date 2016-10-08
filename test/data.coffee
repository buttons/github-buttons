expect = require('chai').expect
{ObjectHelper, NumberHelper, QueryString, Hash} = require('./sandbox').require '../src/data'


describe 'ObjectHelper', ->
  describe '.deepProperty()', ->
    it 'should get undefined when object is missing', ->
      expect ObjectHelper.deepProperty()
        .to.deep.equal undefined

    it 'should get the object itself when path is missing', ->
      expect ObjectHelper.deepProperty {}
        .to.deep.equal {}
      expect ObjectHelper.deepProperty []
        .to.deep.equal []

    it 'should get the deep property when no nested object or array exists', ->
      expect ObjectHelper.deepProperty {
        a: 1, b: 2
      }, "a"
        .to.deep.equal 1

    it 'should get the deep property when single-level nested object exists', ->
      expect ObjectHelper.deepProperty {
        a: 1
        b:
          c: 2
        d: 3
      }, "b.c"
        .to.deep.equal 2

    it 'should get the deep property when multi-level nested object exists', ->
      expect ObjectHelper.deepProperty {
        a:
          b: 1
          c: 2
        d:
          e:
            f: 3
      }, "d.e.f"
        .to.deep.equal 3

    it 'should get the deep property when nested array exists', ->
      expect ObjectHelper.deepProperty {
        a: 1
        b: [2, 3]
        c: 4
      }, "b[1]"
        .to.deep.equal 3

    it 'should get the deep property for array', ->
      expect ObjectHelper.deepProperty [1, 2], "[1]"
        .to.deep.equal 2

    it 'should get the deep property for array when single-level nested array exists', ->
      expect ObjectHelper.deepProperty [1, [2, 3], 4], "[1][1]"
        .to.deep.equal 3

    it 'should get the deep property for array when multi-level nested array exists', ->
      expect ObjectHelper.deepProperty [1, [2, [3, 4]], 5], "[1][1][0]"
        .to.deep.equal 3

    it 'should get the deep property for array when nested object exists', ->
      expect ObjectHelper.deepProperty [1, {a: 2, b: 3}, 4], "[1].a"
        .to.deep.equal 2

    it 'should be able to handle empty string as key', ->
      expect ObjectHelper.deepProperty {"": "test"}, ""
        .to.deep.equal "test"
      expect ObjectHelper.deepProperty {a: "": "": b: "empty"}, "a...b"
        .to.deep.equal "empty"


describe 'NumberHelper', ->
  describe '.numberWithDelimiter()', ->
    it 'should not add delimiter when number has 3 digits or less', ->
      expect NumberHelper.numberWithDelimiter 0
        .to.equal "0"
      expect NumberHelper.numberWithDelimiter 999
        .to.equal "999"

    it 'should not add delimiter when number has 4 digits or more', ->
      expect NumberHelper.numberWithDelimiter 1000
        .to.equal "1,000"
      expect NumberHelper.numberWithDelimiter 2147483647
        .to.equal "2,147,483,647"


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
