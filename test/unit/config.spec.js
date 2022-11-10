import { iframeURL } from '../../src/config'

describe('Config', () => {
  it('should export iframeUrl', () => {
    expect(iframeURL)
      .to.match(/^https:\/\/(?:buttons.github.io|unpkg.com\/github-buttons@.*\/dist)\/buttons.html$/)
  })
})
