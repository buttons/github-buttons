import React from 'react'
import ReactDOM from 'react-dom'
import GithubButtons from 'github-buttons'

export default class GithubButton extends React.Component {
  render () {
    return React.createElement('span', null, React.createElement('a', this.props))
  }
  componentDidMount () {
    GithubButtons.render(this._ = ReactDOM.findDOMNode(this).firstChild)
  }
  componentWillUpdate () {
    ReactDOM.findDOMNode(this).replaceChild(this._, ReactDOM.findDOMNode(this).firstChild)
  }
  componentDidUpdate () {
    GithubButtons.render(this._ = ReactDOM.findDOMNode(this).firstChild)
  }
}
