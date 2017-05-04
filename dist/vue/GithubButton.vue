<script>
import { render } from 'github-buttons'

export default {
  name: 'github-button',
  props: [
    'href',
    'data-icon',
    'data-size',
    'data-show-count',
    'data-text',
    'aria-label'
  ],
  render (createElement) {
    return createElement('span', [
      createElement('a', {
        attrs: {
          'href': this.href,
          'data-icon': this.dataIcon,
          'data-size': this.dataSize,
          'data-show-count': this.dataShowCount,
          'data-text': this.dataText,
          'aria-label': this.ariaLabel
        }
      }, this.$slots.default)
    ])
  },
  mounted () {
    render(this._ = this.$el.firstChild)
  },
  beforeUpdate () {
    this.$el.replaceChild(this._, this.$el.firstChild)
  },
  updated () {
    render(this._ = this.$el.firstChild)
  }
}
</script>
