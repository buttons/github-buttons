import { iframeURL } from '@/config'

describe('Config', () => {
  it('should export iframeUrl', () => {
    expect(iframeURL)
      .to.match(/^https:\/\/(?:buttons.github.io|unpkg.com\/github-buttons@.*\/dist)\/buttons.html$/)
  })
})
