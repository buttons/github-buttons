github-buttons
==============

[![Circle CI](https://circleci.com/gh/ntkme/github-buttons.svg?style=svg)](https://circleci.com/gh/ntkme/github-buttons)

To get started, checkout **[buttons.github.io](https://buttons.github.io)**!  

## Features

- **Unlimited Button Types**  
  Our [github:button generator](https://buttons.github.io) provides 6 basic button types including follow, watch, star, fork, issue and download, each at normal or large size, with or without a dynamic count.  In addition, the buttons are customizable via simple HTML markup.
- **Pixel Perfect**  
  [Octicons](https://octicons.github.com) based vector icons always look sharp on every display.  The automatically sized iframe solves the big headache of iframe sizing.  Plus, its high precision sizing algorithm works the best for HiDPI displays.
- **Fast**  
  Hosted on [GitHub Pages](https://pages.github.com), this service delivers high performance and availability, using asynchronous code that never blocks the page loading.
- **Stable**  
  High test coverage for the [main library](buttons.js) and automated tests on [Circle CI](https://circleci.com/gh/ntkme/github-buttons) assure the service quality.
- **Backward Compatible**  
  As you may still need this, outdated browsers like IE 6 are supported.
- **Accessibility**  
  ARIA label support enables accessibility for screen reader users.

## Documentation

### Usage

Add as many `<a class="github-button">` as you like, then put the `<script>` anywhere on your page.

### Syntax

``` html
<a class="github-button"
   href="{{ link }}"
   data-icon="{{ octicon }}"
   data-show-count="{{ show count }}"
   data-style="{{ style }}"
   data-text="{{ text }}"
   aria-label="{{ aria label }}"
   >{{ text }}</a>
```

``` html
<script async defer src="https://buttons.github.io/buttons.js"></script>
```

#### Config

| Attribute               | Description                                                                                                                                     |
| ---------               | -----------                                                                                                                                     |
| `href`                  | GitHub link for the button.                                                                                                                     |
| `data-icon`             | Octicon for the button. It defaults to `octicon-mark-github`. <br> All available icons can be found at [Octicons](https://octicons.github.com). |
| `data-count-api`        | Deprecated. Same as `data-show-count="true"`.                                                                                                   |
| `data-count-href`       | Obsoleted.                                                                                                                                      |
| `data-count-aria-label` | Obsoleted.                                                                                                                                      |
| `data-show-count`       | `true` or `false`.                                                                                                                              |
| `data-style`            | `default` or `mega`.                                                                                                                            |
| `data-text`             | Text displayed on the button. It defaults to the text content within the link.                                                                  |
| `aria-label`            | Aira label for the button link.                                                                                                                 |

### Advanced Usage

This module works with CommonJS or AMD loader. *Keep in mind that it works only in browser.*

**It is recommended to use a module bundler rather than a module loader.**

To create buttons dynamically, you will use the `render()` function, which is a named export of this module.

``` javascript
var GitHubButtons = require('github-buttons')
GitHubButtons.render(target, config)
```

`target` is a DOM node to be replaced by the button, and `config` is an object containing the attributes.

``` javascript
GitHubButtons.render(target)
```

`target` must be an AnchorElement (`<a>`) containing the attributes if `config` is not provided.



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
cake build
```

### Test

``` sh
cake test
```



See also
--------

- [mdo/github-buttons](https://ghbtns.com)



License
-------

See [LICENSE.md](LICENSE.md).
