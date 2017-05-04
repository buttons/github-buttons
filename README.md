github-buttons
==============

[![Circle CI](https://circleci.com/gh/ntkme/github-buttons.svg?style=svg)](https://circleci.com/gh/ntkme/github-buttons)

To get started, checkout **[buttons.github.io](https://buttons.github.io)**!  

Documentation
-------------

### Quick Start

The easiest way to get started is to use the **[github:button generator](https://buttons.github.io)**.

### Components

- [GithubButton.vue](dist/vue) for [Vue](https://vuejs.org)
- [GitHubButton.js](dist/react/) for [React](https://facebook.github.io/react/)
- [github-button.component.ts](dist/angular/) for [Angular](https://angular.io)

### Basic Usage (without component)

#### Markup Syntax

``` html
<!-- Place this tag where you want the button to render. -->
<a class="github-button"
   href="{{ link }}"
   data-icon="{{ octicon }}"
   data-size="{{ size }}"
   data-show-count="{{ show count }}"
   data-text="{{ text }}"
   aria-label="{{ aria label }}"
   >{{ text }}</a>
```

``` html
<!-- Place this tag in your head or just before your close body tag. -->
<script async defer src="https://buttons.github.io/buttons.js"></script>
```

#### Config

| Attribute               | Description                                                                                                                  |
| ---------               | -----------                                                                                                                  |
| `href`                  | GitHub link for the button.                                                                                                  |
| `data-icon`             | Octicon for the button. `octicon-mark-github`. <br> Available icons can be found at [Octicons](https://octicons.github.com). |
| `data-size`             | _None_ by default or `large`.                                                                                                |
| `data-show-count`       | `false` by default or `true`. The dynamic count is generated based on detected button type.                                  |
| `data-text`             | Text displayed on the button. It defaults to the text content within the link.                                               |
| `aria-label`            | Aira label for the button link.                                                                                              |

#### Built-in Button Types

Button type is detected through button's `href` attribute.

- `https://github.com/:user` (follow)
- `https://github.com/:user/:repo` (star)
- `https://github.com/:user/:repo/subscription` (watch)
- `https://github.com/:user/:repo/fork` (fork)
- `https://github.com/:user/:repo/issues` (issues)
- `https://github.com/:user/:repo/issues/new` (issues)

Tailing slash, query string, and hash in the `href` are handled.

- `https://github.com/:user/` (follow)
- `https://github.com/:user?tab=repositories` (follow)
- `https://github.com/:user/:repo#license` (star)
- `https://github.com/:user/:repo/#license` (star)

### Advanced Usage

#### Import as a Module

This module works with CommonJS or AMD loader. *Keep in mind that it works only in browser.*

``` javascript
var GitHubButtons = require('github-buttons')
```

It is recommended to use a module bundler rather than a module loader.

#### Render a Button

To create buttons dynamically, you will use the `render()` function, which is a named export of this module.

``` javascript
GitHubButtons.render(target, config)
```

- `target` is a DOM node to be replaced by a button.
- `config` is an object containing the attributes.

To append the button to a parent node instead, you need to create a placeholder as target.

``` javascript
GitHubButtons.render(parentNode.appendChild(document.createElement('span')), config)
```

Alternatively, config can be read from the `target` if it is an Anchor (`<a>`) with attributes. 

``` javascript
GitHubButtons.render(target)
```




Development
-----------

### Clone

``` sh
git clone --recursive https://github.com/ntkme/github-buttons.git
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

See [LICENSE.md](LICENSE.md).
