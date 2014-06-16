github-buttons
==============

[github:buttons](https://buttons.github.io)

## We already have [ghbtns.com](http://ghbtns.com), why don't use that?

The famous [mdo/github-buttons](https://github.com/mdo/github-buttons) has several limitations listed at [mdo/github-buttons#limitations](https://github.com/mdo/github-buttons#limitations). This project was borned to overcome those limitations, especially to solve the most annoying manual iframe sizing! Also, this project was designed to have max flexibility. Thus no pre-defined button type is provided here, but you can customize almost everything, such as link, text, icon, size, count and **API**. Don't panic, there are a bunch of templates for you to start with.

By the way, if you want to create a button for a another sevice, feel free to fork this project and hack into it.

Usage
-----

``` html
<a href="https://github.com/ntkme" class="github-button"
  data-count-href="/ntkme/followers" data-count-api="/users/ntkme#followers">Follow @ntkme</a>
<a href="https://github.com/ntkme/github-buttons" class="github-button" data-icon="octicon-star"
  data-count-href="/ntkme/github-buttons/stargazers" data-count-api="/repos/ntkme/github-buttons#stargazers_count">Star</a>
<a href="https://github.com/ntkme/github-buttons" class="github-button" data-icon="octicon-git-branch"
  data-count-href="/ntkme/github-buttons/network" data-count-api="/repos/ntkme/github-buttons#forks_count">Fork</a>
<a href="https://github.com/ntkme/github-buttons/issues" class="github-button" data-icon="octicon-issue-opened"
  data-count-api="/repos/ntkme/github-buttons#open_issues_count">Issue</a>

<script async defer id="github-bjs" src="https://buttons.github.io/buttons.js"></script>
```

Add as many `<a class="github-button">` as you like, then put the `<script>` after the last button.

### Syntax

``` html
<a class="github-button"
   href="{{ link }}"
   data-style="{{ style }}"
   data-icon="{{ octicon }}"
   data-text="{{ button_text }}"
   data-count-href="{{ count_link }}"
   data-count-api="{{ count_api }}"
   >{{ link_text }}</a>
```

``` html
<script async defer id="github-bjs" src="https://buttons.github.io/buttons.js"></script>
```

#### Required

```
class="github-button"
```

GitHub button class.

```
href="{{ link }}"
```

GitHub link for the button.

#### Optional

```
{{ link_text }}
```

Text on the button and the fallback link.

```
data-text="{{ button_text }}"
```

Text on the button. This option will override `{{ link_text }}`.

```
data-style="{{ style }}"
```

Style can be `default` or `mega`.

```
data-icon="{{ octicon }}"
```

Octicon for the button. The default is `octicon-mark-github`.

All available icons can be found at [Octicons](https://octicons.github.com).

```
data-count-href="{{ count_link }}"
```

GitHub link for the count. This is default to the same url of the button's link. If a relative url is given, it will be relative to the button's link.

```
data-count-api="{{ count_api }}"
```

GitHub api endpoint for the count. See the [GitHub Developer](https://developer.github.com) for the references. The `#hash` appended to the api endpoint is used for accessing a specific node in the json response. You can also combine hashes like `#node.child_node.child_node` to access child nodes.

The button will show the count only if `data-count-api` is defined.


License
-------

See [LICENSE.md](LICENSE.md).
