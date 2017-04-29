describe "QueryString", ->

  describe "stringifyQueryString(obj)", ->
    it "should stringify object when object is empty", ->
      expect stringifyQueryString {}
        .to.equal ""

    it "should not stringify object when key in object does not have value", ->
      expect stringifyQueryString test: null
        .to.equal ""

    it "should stringify object when key in object does have value", ->
      expect stringifyQueryString hello: "world"
        .to.equal "hello=world"

      expect stringifyQueryString hello: ""
        .to.equal "hello="

      expect stringifyQueryString hello: false
        .to.equal "hello=false"

    it "should stringify object", ->
      expect stringifyQueryString hello: "world", test: null
        .to.equal "hello=world"

  describe "parseQueryString(str)", ->
    it "should parse string when string is empty", ->
      expect parseQueryString ""
        .to.deep.equal {}

    it "should parse string", ->
      expect parseQueryString "hello=world&test="
        .to.deep.equal
          hello: "world"
          test: ""
