expect = require('chai').expect
{FlatObject, QueryString, Hash} = require('./sandbox').require '../src/data'


describe 'FlatObject', ->
  describe '.flatten()', ->
    it 'should flatten object when object is empty', ->
      expect FlatObject.flatten {}
        .to.deep.equal {}

    it 'should flatten object when no nested object or array exists', ->
      expect FlatObject.flatten {
        a: 1
        b: 2
      }
        .to.deep.equal
          "a": 1
          "b": 2

    it 'should flatten object when single-level nested object exists', ->
      expect FlatObject.flatten {
        a: 1
        b:
          c: 2
        d: 3
      }
        .to.deep.equal
          "a": 1
          "b.c": 2
          "d": 3

    it 'should flatten object when multiple-level nested object exists', ->
      expect FlatObject.flatten {
        a:
          b: 1
          c: 2
        d:
          e:
            f: 3
      }
        .to.deep.equal
          "a.b": 1
          "a.c": 2
          "d.e.f": 3

    it 'should flatten object when nested array exists', ->
      expect FlatObject.flatten {
        a: 1
        b: [2, 3]
        c: 4
      }
        .to.deep.equal
          "a": 1
          "b[0]": 2
          "b[1]": 3
          "c": 4

    it 'should flatten array when array is empty', ->
      expect FlatObject.flatten []
        .to.deep.equal {}

    it 'should flatten array when no nested object or array exists', ->
      expect FlatObject.flatten [1, 2]
        .to.deep.equal
          "[0]": 1
          "[1]": 2

    it 'should flatten array when single-level nested array exists', ->
      expect FlatObject.flatten [1, [2, 3], 4]
        .to.deep.equal
          "[0]": 1
          "[1][0]": 2
          "[1][1]": 3
          "[2]": 4

    it 'should flatten array when multiple-level nested array exists', ->
      expect FlatObject.flatten [1, [2, [3, 4]], 5]
        .to.deep.equal
          "[0]": 1
          "[1][0]": 2
          "[1][1][0]": 3
          "[1][1][1]": 4
          "[2]": 5

    it 'should flatten array when nested object exists', ->
      expect FlatObject.flatten [1, {a: 2, b: 3}, 4]
        .to.deep.equal
          "[0]": 1
          "[1].a": 2
          "[1].b": 3
          "[2]": 4

  describe '.expand()', ->
    it 'should not expand obejct when obejct is empty', ->
      expect FlatObject.expand {}
        .to.equal undefined

    it 'should expnad object as object', ->
      expect FlatObject.expand {
        "a": 1
        "b.c": 2
        "b.d[0]": 3
        "b.d[1].e": 4
        "f[0]": 5
        "f[1]": 6
      }
        .to.deep.equal
          a: 1
          b:
            c: 2
            d: [3, e: 4]
          f: [5, 6]

    it 'should expand object as array', ->
      expect FlatObject.expand {
        "[0]": 1
        "[1][0]": 2
        "[1][1].a": 3
        "[1][1].b[0]": 4
        "[2].c": 5
        "[2].d": 6
      }
        .to.deep.equal [1, [2, {a: 3, b: [4]}], {c: 5, d: 6}]


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
