import {
  setDevicePixelRatio,
  ceilPixel
} from '@/pixel'

describe('Pixel', () => {
  describe('ceilPixel(px)', () => {
    afterEach(() => {
      setDevicePixelRatio(window.devicePixelRatio)
    })

    it('should assume the devicePixelRatio is 1 if not available', () => {
      setDevicePixelRatio(null)
      expect(ceilPixel(1)).to.equal(1)
      expect(ceilPixel(1.5)).to.equal(2)
      expect(ceilPixel(1.25)).to.equal(2)
    })

    it('should ceil the pixel when devicePixelRatio is 1', () => {
      setDevicePixelRatio(1)
      expect(ceilPixel(1)).to.equal(1)
      expect(ceilPixel(1.5)).to.equal(2)
      expect(ceilPixel(1.25)).to.equal(2)
    })

    it('should ceil the pixel to 1/2 when devicePixelRatio is 2', () => {
      setDevicePixelRatio(2)
      expect(ceilPixel(1)).to.equal(1)
      expect(ceilPixel(1.25)).to.equal(1.5)
      expect(ceilPixel(1.5)).to.equal(1.5)
      expect(ceilPixel(1.75)).to.equal(2)
    })

    it('should round the pixel to 1/3 then ceil the pixel to 1/2 when devicePixelRatio is 3', () => {
      setDevicePixelRatio(3)
      expect(ceilPixel(1)).to.equal(1)
      expect(ceilPixel(1.16)).to.equal(1)
      expect(ceilPixel(1.17)).to.equal(1.5)
      expect(ceilPixel(1.25)).to.equal(1.5)
      expect(ceilPixel(1.33)).to.equal(1.5)
      expect(ceilPixel(1.34)).to.equal(1.5)
      expect(ceilPixel(1.5)).to.equal(2)
      expect(ceilPixel(1.66)).to.equal(2)
      expect(ceilPixel(1.67)).to.equal(2)
      expect(ceilPixel(1.75)).to.equal(2)
      expect(ceilPixel(1.83)).to.equal(2)
      expect(ceilPixel(1.84)).to.equal(2)
      expect(ceilPixel(2)).to.equal(2)
    })

    it('should 0 for NaN', () => {
      expect(ceilPixel(NaN)).to.equal(0)
      expect(ceilPixel(null)).to.equal(0)
      expect(ceilPixel(undefined)).to.equal(0)
    })
  })
})
