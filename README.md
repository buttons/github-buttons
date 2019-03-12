github-buttons
==============

[![CircleCI](https://img.shields.io/circleci/project/github/ntkme/github-buttons/master.svg)](https://circleci.com/gh/ntkme/github-buttons)
[![Codecov](https://img.shields.io/codecov/c/github/ntkme/github-buttons.svg)](https://codecov.io/gh/ntkme/github-buttons)

Usage
-----

### Use as a Snippet

Get started quickly with **[github:button configurator](https://buttons.github.io)**.

The source code for the configurator is available at [ntkme/github-buttons-app](https://github.com/ntkme/github-buttons-app).

### Use as a Module

``` javascript
import { render } from 'github-buttons'

// export function render(anchor: HTMLAnchorElement, callback: (el: HTMLElement) => void): void;
render(anchor, function (el) {
  anchor.parentNode.replaceChild(el, anchor)
})

// export function render(options: object, callback: (el: HTMLElement) => void): void;
render(options, function (el) {
  document.body.appendChild(el) 
})
```

### Use as a Component

- [vue-github-button](https://github.com/ntkme/vue-github-button) for [Vue](https://vuejs.org)
- [react-github-btn](https://github.com/ntkme/react-github-btn) for [React](https://reactjs.org)

### Options 

These options are the same for all the use cases described above:

| Attribute         | Description                                                                                                           |
| ---------         | -----------                                                                                                           |
| `href`            | GitHub link for the button.                                                                                           |
| `title`           | `title` attribute for the button's rendered element.                                                                  |
| `data-icon`       | `octicon-mark-github` by default. A [subset](rollup.config.js) of [Octicons](https://octicons.github.com) is bundled. |
| `data-size`       | _None_ by default or `large`.                                                                                         |
| `data-show-count` | `false` by default or `true`. The dynamic count is generated based on detected button type.                           |
| `data-text`       | Text displayed on the button. It defaults to the text content within the link.                                        |
| `aria-label`      | Aira label for the button link.                                                                                       |

##### Built-in Button Types

Button type is detected from `href`.

- `https://github.com/:user` (follow)
- `https://github.com/:user/:repo` (star)
- `https://github.com/:user/:repo/subscription` (watch)
- `https://github.com/:user/:repo/fork` (fork)
- `https://github.com/:user/:repo/issues` (issues)
- `https://github.com/:user/:repo/issues/new` (issues)

Tailing slash, query string, and hash in the `href` won't affect type detection.

- `https://github.com/:user/` (follow)
- `https://github.com/:user?tab=repositories` (follow)
- `https://github.com/:user/:repo#readme` (star)
- `https://github.com/:user/:repo/#readme` (star)


Development
-----------

### Clone

``` sh
git clone https://github.com/ntkme/github-buttons.git
```

``` sh
cd github-buttons && npm install
```

### Build

``` sh
npm run build
```

### Test

``` sh
npm test
```



See also
--------

- [mdo/github-buttons](https://ghbtns.com)



License
-------

See [LICENSE](LICENSE).
