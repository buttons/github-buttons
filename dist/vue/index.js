import { render } from 'github-buttons'

export default {
  name: 'github-button',
  render (h) {
    return h('span', [
      h('a', { attrs: this.$attrs }, this.$slots.default)
    ])
  },
  mounted () {
    render(this._ = this.$el.lastChild)
  },
  beforeUpdate () {
    this.$el.replaceChild(this._, this.$el.lastChild)
  },
  updated () {
    render(this._ = this.$el.lastChild)
  }
}
