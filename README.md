github-buttons
==============

[![Circle CI](https://circleci.com/gh/ntkme/github-buttons.svg?style=svg)](https://circleci.com/gh/ntkme/github-buttons)

To get started, checkout **[buttons.github.io](https://buttons.github.io)**!  

## Features

- **Unlimited Button Types**  
  Our [github:button generator](https://buttons.github.io) provides 6 basic button types including follow, watch, star, fork, issue and download, each at normal or large size, with or without a dynamic count.  In addition, almost everything including the API for dynamic count is customizable via simple HTML markup.
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
   data-count-href="{{ count_link }}"
   data-count-api="{{ count_api }}"
   data-count-aria-label="{{ count_aria_label }}"
   data-style="{{ style }}"
   data-text="{{ button_text }}"
   aria-label="{{ button_aria_label }}"
   >{{ text }}</a>
```

``` html
<script async defer src="https://buttons.github.io/buttons.js"></script>
```

#### Attributes

| Attribute               | Description                                                                                                                                     |
| ---------               | -----------                                                                                                                                     |
| `href`                  | GitHub link for the button.                                                                                                                     |
| `data-icon`             | Octicon for the button. It defaults to `octicon-mark-github`. <br> All available icons can be found at [Octicons](https://octicons.github.com). |
| `data-count-href`       | GitHub link for the count. It defaults to `href` value. <br> Relative url will be relative to `href` value.                                     |
| `data-count-api`        | GitHub API endpoint for the count.                                                                                                              |
| `data-count-aria-label` | Aria label for the count link. <br> `#` in this attribute will be replaced with a real count.                                                   |
| `data-style`            | `default` or `mega`.                                                                                                                            |
| `data-text`             | Text displayed on the button. This option will override `link_text`.                                                                            |
| `text`                  | Text displayed on the button and the fallback link.                                                                                             |
| `aria-label`            | Aira label for the button link.                                                                                                                 |

#### API Endpoint

You can use any GitHub API endpoint that supports GET request.  

You must append a `#hash` to the endpoint to extract a value for the count from the JSON response.  
e.g. `/users/octocat#followers` will extract `followers` from the JSON.  

You can also access specific subnode in the JSON.  
e.g. `/repos/octocat/hello-world#owner.login` will extract `owner.login`.  
e.g. `/users/octocat/repos#[0].open_issues_count` will extract `open_issues_count` from the first enrty in the array.  

See [GitHub Developer](https://developer.github.com) for API references.



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
