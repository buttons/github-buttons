import {
  onEvent,
  onceEvent
} from '@/event'

describe('Event', () => {
  let input

  beforeEach(() => {
    input = document.body.appendChild(document.createElement('input'))
  })

  afterEach(() => {
    input.parentNode.removeChild(input)
  })

  describe('onEvent(target, eventName, func)', () => {
    it('should call the function on event', () => {
      const spy = sinon.spy()
      onEvent(input, 'click', spy)
      input.click()
      expect(spy)
        .to.have.been.calledOnce
      input.click()
      expect(spy)
        .to.have.been.calledTwice
    })
  })

  describe('onceEvent(target, eventName, func)', () => {
    it('should call the function on event only once', () => {
      const spy = sinon.spy()
      onceEvent(input, 'click', spy)
      input.click()
      expect(spy)
        .to.have.been.calledOnce
      input.click()
      expect(spy)
        .to.have.been.calledOnce
      input.click()
      expect(spy)
        .to.have.been.calledOnce
    })
  })
})
