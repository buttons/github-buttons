import React from 'react'
import ReactDOM from 'react-dom'
import { render } from 'github-buttons'

export default class GitHubButton extends React.Component {
  render () {
    return React.createElement('span', null, React.createElement('a', this.props, this.props.children))
  }
  componentDidMount () {
    render(this._ = ReactDOM.findDOMNode(this).firstChild)
  }
  componentWillUpdate () {
    ReactDOM.findDOMNode(this).replaceChild(this._, ReactDOM.findDOMNode(this).firstChild)
  }
  componentDidUpdate () {
    render(this._ = ReactDOM.findDOMNode(this).firstChild)
  }
}
