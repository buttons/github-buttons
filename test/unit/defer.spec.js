import { defer } from '@/defer'

describe('Defer', () => {
  describe('defer(func)', () => {
    it('should call the function', (done) => {
      defer(() => {
        done()
      })
    })
  })
})
