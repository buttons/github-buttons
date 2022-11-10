import {
  document,
  location,
  Math
} from '../../src/globals'

describe('Globals', () => {
  it('should export an alias for window.document', () => {
    expect(document)
      .to.equal(window.document)
  })

  it('should export an alias for window.document', () => {
    expect(location)
      .to.equal(document.location)
  })

  it('should export an alias for window.Math', () => {
    expect(Math)
      .to.equal(window.Math)
  })
})
