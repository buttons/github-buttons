import {
  stringify,
  parse
} from '@/querystring'

describe('QueryString', () => {
  describe('stringify(obj)', () => {
    it('should stringify object when object is empty', () => {
      expect(stringify({}))
        .to.equal('')
    })

    it('should not stringify object when key in object does not have value', () => {
      expect(stringify({
        test: null
      }))
        .to.equal('')
    })

    it('should stringify object when key in object does have value', () => {
      expect(stringify({
        hello: 'world'
      }))
        .to.equal('hello=world')
      expect(stringify({
        hello: ''
      }))
        .to.equal('hello=')
      expect(stringify({
        hello: false
      }))
        .to.equal('hello=false')
    })

    it('should stringify object when key is empty string', () => {
      expect(stringify({
        '': ''
      }))
        .to.equal('=')
    })

    it('should stringify object', () => {
      expect(stringify({
        hello: 'world',
        test: null
      }))
        .to.equal('hello=world')
    })
  })

  describe('parse(str)', () => {
    it('should parse string when string is empty', () => {
      expect(parse(''))
        .to.deep.equal({})
    })

    it('should parse string when a key does not have value or have empty value', () => {
      expect(parse('hello&test='))
        .to.deep.equal({
          hello: undefined,
          test: ''
        })
    })

    it('should parse string when a key is empty string', () => {
      expect(parse('=&hello=world'))
        .to.deep.equal({
          '': '',
          hello: 'world'
        })
    })

    it('should parse string', () => {
      expect(parse('hello=world&test=1234'))
        .to.deep.equal({
          hello: 'world',
          test: '1234'
        })
    })
  })
})
