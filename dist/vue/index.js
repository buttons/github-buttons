import { render } from 'github-buttons'

export default {
  name: 'github-button',
  render (h) {
    return h('a', this.$slots.default)
  },
  mounted () {
    render(this.$el.parentNode.insertBefore(this._ = document.createElement('span'), this.$el).appendChild(this.$el))
  },
  beforeUpdate () {
    this._.parentNode.replaceChild(this.$el, this._)
  },
  updated () {
    render(this.$el.parentNode.insertBefore(this._ = document.createElement('span'), this.$el).appendChild(this.$el))
  }
}
