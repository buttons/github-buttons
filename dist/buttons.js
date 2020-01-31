/*!
 * github-buttons v2.7.0
 * (c) 2020 なつき
 * @license BSD-2-Clause
 */
(function () {
  'use strict';

  var document = window.document;

  var location = document.location;

  var Math = window.Math;

  var HTMLElement = window.HTMLElement;

  var XMLHttpRequest = window.XMLHttpRequest;

  var buttonClass = 'github-button';

  var iframeURL = 'https://' + (/* istanbul ignore next */  'buttons.github.io') + '/buttons.html';

  var apiBaseURL = 'https://api.github.com';

  var useXHR = XMLHttpRequest && XMLHttpRequest.prototype && 'withCredentials' in XMLHttpRequest.prototype;

  var useShadowDOM = useXHR && HTMLElement && HTMLElement.prototype.attachShadow && !HTMLElement.prototype.attachShadow.prototype;

  var stringify = function (obj, sep, eq, encodeURIComponent) {
    if (sep == null) {
      sep = '&';
    }
    if (eq == null) {
      eq = '=';
    }
    if (encodeURIComponent == null) {
      encodeURIComponent = window.encodeURIComponent;
    }
    var params = [];
    for (var name in obj) {
      var value = obj[name];
      if (value != null) {
        params.push(encodeURIComponent(name) + eq + encodeURIComponent(value));
      }
    }
    return params.join(sep)
  };

  var parse = function (str, sep, eq, decodeURIComponent) {
    if (sep == null) {
      sep = '&';
    }
    if (eq == null) {
      eq = '=';
    }
    if (decodeURIComponent == null) {
      decodeURIComponent = window.decodeURIComponent;
    }
    var obj = {};
    var params = str.split(sep);
    for (var i = 0, len = params.length; i < len; ++i) {
      var entry = params[i];
      if (entry !== '') {
        var ref = entry.split(eq);
        obj[decodeURIComponent(ref[0])] = (ref[1] != null ? decodeURIComponent(ref.slice(1).join(eq)) : undefined);
      }
    }
    return obj
  };

  var onEvent = function (target, eventName, func) {
    /* istanbul ignore else: IE lt 9 */
    if (target.addEventListener) {
      target.addEventListener(eventName, func, false);
    } else {
      target.attachEvent('on' + eventName, func);
    }
  };

  var offEvent = function (target, eventName, func) {
    /* istanbul ignore else: IE lt 9 */
    if (target.removeEventListener) {
      target.removeEventListener(eventName, func, false);
    } else {
      target.detachEvent('on' + eventName, func);
    }
  };

  var onceEvent = function (target, eventName, func) {
    var callback = function (event) {
      offEvent(target, eventName, callback);
      return func(event)
    };
    onEvent(target, eventName, callback);
  };

  var onceReadyStateChange = /* istanbul ignore next: IE lt 9 */ function (target, regex, func) {
    var eventName = 'readystatechange';
    var callback = function (event) {
      if (regex.test(target.readyState)) {
        offEvent(target, eventName, callback);
        return func(event)
      }
    };
    onEvent(target, eventName, callback);
  };

  var createElementInDocument = function (document) {
    return function (tag, props, children) {
      var el = document.createElement(tag);
      if (props) {
        for (var prop in props) {
          var val = props[prop];
          if (val != null) {
            if (el[prop] != null) {
              el[prop] = val;
            } else {
              el.setAttribute(prop, val);
            }
          }
        }
      }
      if (children) {
        for (var i = 0, len = children.length; i < len; i++) {
          var child = children[i];
          el.appendChild(typeof child === 'string' ? document.createTextNode(child) : child);
        }
      }
      return el
    }
  };

  var createElement = createElementInDocument(document);

  var dispatchOnce = function (func) {
    var onceToken;
    return function () {
      if (!onceToken) {
        onceToken = 1;
        func.apply(this, arguments);
      }
    }
  };

  var hasOwnProperty = function (obj, prop) {
    return {}.hasOwnProperty.call(obj, prop)
  };

  var defer = function (func) {
    /* istanbul ignore else */
    if (/m/.test(document.readyState) || /* istanbul ignore next */ (!/g/.test(document.readyState) && !document.documentElement.doScroll)) {
      setTimeout(func);
    } else {
      if (document.addEventListener) {
        var callback = dispatchOnce(func);
        onceEvent(document, 'DOMContentLoaded', callback);
        onceEvent(window, 'load', callback);
      } else {
        onceReadyStateChange(document, /m/, func);
      }
    }
  };

  var buttonsCssText = "body{margin:0}a{text-decoration:none;outline:0}.widget{display:inline-block;overflow:hidden;font-family:-apple-system,BlinkMacSystemFont,Segoe UI,Helvetica,Arial,sans-serif;font-size:0;white-space:nowrap}.btn,.social-count{position:relative;display:inline-block;height:14px;padding:2px 5px;font-size:11px;font-weight:600;line-height:14px;vertical-align:bottom;cursor:pointer;-webkit-user-select:none;-moz-user-select:none;-ms-user-select:none;user-select:none;background-repeat:repeat-x;background-position:-1px -1px;background-size:110% 110%;border:1px solid}.btn{border-radius:.25em}.btn:not(:last-child){border-radius:.25em 0 0 .25em}.social-count{border-left:0;border-radius:0 .25em .25em 0}.widget-lg .btn,.widget-lg .social-count{height:20px;padding:3px 10px;font-size:12px;line-height:20px}.octicon{display:inline-block;vertical-align:text-top;fill:currentColor}";

  var light = ".btn{color:#24292e;background-color:#eff3f6;background-image:url(\"data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg'%3e%3clinearGradient id='o' x2='0' y2='1'%3e%3cstop stop-color='%23fafbfc'/%3e%3cstop offset='90%25' stop-color='%23eff3f6'/%3e%3c/linearGradient%3e%3crect width='100%25' height='100%25' fill='url(%23o)'/%3e%3c/svg%3e\");background-image:-moz-linear-gradient(top, #fafbfc, #eff3f6 90%);background-image:linear-gradient(180deg, #fafbfc, #eff3f6 90%);filter:progid:DXImageTransform.Microsoft.Gradient(startColorstr='#FFFAFBFC', endColorstr='#FFEEF2F5');border-color:#cdcfd1;border-color:rgba(27,31,35,.2)}:root .btn{filter:none}.btn:focus,.btn:hover{background-color:#e6ebf1;background-image:url(\"data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg'%3e%3clinearGradient id='o' x2='0' y2='1'%3e%3cstop stop-color='%23f0f3f6'/%3e%3cstop offset='90%25' stop-color='%23e6ebf1'/%3e%3c/linearGradient%3e%3crect width='100%25' height='100%25' fill='url(%23o)'/%3e%3c/svg%3e\");background-image:-moz-linear-gradient(top, #f0f3f6, #e6ebf1 90%);background-image:linear-gradient(180deg, #f0f3f6, #e6ebf1 90%);filter:progid:DXImageTransform.Microsoft.Gradient(startColorstr='#FFF0F3F6', endColorstr='#FFE5EAF0');background-position:-0.5em;border-color:#acaeb0;border-color:rgba(27,31,35,.35)}:root .btn:focus,:root .btn:hover{filter:none}.btn:active{background-color:#e9ecef;background-image:none;border-color:#acaeb0;border-color:rgba(27,31,35,.35);box-shadow:inset 0 .15em .3em rgba(27,31,35,.15);filter:none}.social-count{color:#24292e;background-color:#fff;border-color:#d1d2d3;border-color:rgba(27,31,35,.2)}.social-count:focus,.social-count:hover{color:#0366d6}.octicon-heart{color:#ea4aaa}";

  var dark = ".btn{color:#fafbfc;background-color:#202428;background-image:url(\"data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg'%3e%3clinearGradient id='o' x2='0' y2='1'%3e%3cstop stop-color='%232f363d'/%3e%3cstop offset='90%25' stop-color='%23202428'/%3e%3c/linearGradient%3e%3crect width='100%25' height='100%25' fill='url(%23o)'/%3e%3c/svg%3e\");background-image:-moz-linear-gradient(top, #2f363d, #202428 90%);background-image:linear-gradient(180deg, #2f363d, #202428 90%);filter:progid:DXImageTransform.Microsoft.Gradient(startColorstr='#FF2F363D', endColorstr='#FF1E2226');border-color:#2b3138;border-color:rgba(27,31,35,.2)}:root .btn{filter:none}.btn:focus,.btn:hover{background-color:#1b1f23;background-image:url(\"data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg'%3e%3clinearGradient id='o' x2='0' y2='1'%3e%3cstop stop-color='%232b3137'/%3e%3cstop offset='90%25' stop-color='%231b1f23'/%3e%3c/linearGradient%3e%3crect width='100%25' height='100%25' fill='url(%23o)'/%3e%3c/svg%3e\");background-image:-moz-linear-gradient(top, #2b3137, #1b1f23 90%);background-image:linear-gradient(180deg, #2b3137, #1b1f23 90%);filter:progid:DXImageTransform.Microsoft.Gradient(startColorstr='#FF2B3137', endColorstr='#FF191D21');background-position:-0.5em;border-color:#252b30;border-color:rgba(27,31,35,.5)}:root .btn:focus,:root .btn:hover{filter:none}.btn:active{background-color:#181b1f;background-image:none;border-color:#252b30;border-color:rgba(27,31,35,.5);box-shadow:inset 0 .15em .3em rgba(27,31,35,.15);filter:none}.social-count{color:#fafbfc;background-color:#1b1f23;border-color:#1b1f23;border-color:rgba(27,31,35,.2)}.social-count:focus,.social-count:hover{color:#2188ff}.octicon-heart{color:#ec6cb9}";

  var widgetColorSchemes = {
    light: light,
    dark: dark
  };

  var getColorSchemeMediaQuery = function (systemColorScheme, widgetColorScheme) {
    return '@media(prefers-color-scheme:' + systemColorScheme + '){' + widgetColorSchemes[hasOwnProperty(widgetColorSchemes, widgetColorScheme) ? widgetColorScheme : systemColorScheme] + '}'
  };

  var getColorScheme = function (declarations) {
    if (declarations == null) {
      return widgetColorSchemes.light
    }

    var colorSchemes = parse(declarations, ';', ':', function (str) {
      return str.replace(/^[ \t\n\f\r]+|[ \t\n\f\r]+$/g, '')
    });

    return widgetColorSchemes[hasOwnProperty(widgetColorSchemes, colorSchemes['no-preference']) ? colorSchemes['no-preference'] : 'light'] +
      getColorSchemeMediaQuery('light', colorSchemes.light) +
      getColorSchemeMediaQuery('dark', colorSchemes.dark)
  };

  var data = {"mark-github":{"width":16,"height":16,"path":"<path fill-rule=\"evenodd\" d=\"M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0016 8c0-4.42-3.58-8-8-8z\"/>"},"heart":{"width":12,"height":16,"path":"<path fill-rule=\"evenodd\" d=\"M8.727 3C7.091 3 6.001 4.65 6.001 4.65S4.909 3 3.273 3C1.636 3 0 4.1 0 6.3 0 9.6 6 14 6 14s6-4.4 6-7.7C12 4.1 10.364 3 8.727 3z\"/>"},"eye":{"width":16,"height":16,"path":"<path fill-rule=\"evenodd\" d=\"M8.06 2C3 2 0 8 0 8s3 6 8.06 6C13 14 16 8 16 8s-3-6-7.94-6zM8 12c-2.2 0-4-1.78-4-4 0-2.2 1.8-4 4-4 2.22 0 4 1.8 4 4 0 2.22-1.78 4-4 4zm2-4c0 1.11-.89 2-2 2-1.11 0-2-.89-2-2 0-1.11.89-2 2-2 1.11 0 2 .89 2 2z\"/>"},"star":{"width":14,"height":16,"path":"<path fill-rule=\"evenodd\" d=\"M14 6l-4.9-.64L7 1 4.9 5.36 0 6l3.6 3.26L2.67 14 7 11.67 11.33 14l-.93-4.74L14 6z\"/>"},"repo-forked":{"width":10,"height":16,"path":"<path fill-rule=\"evenodd\" d=\"M8 1a1.993 1.993 0 00-1 3.72V6L5 8 3 6V4.72A1.993 1.993 0 002 1a1.993 1.993 0 00-1 3.72V6.5l3 3v1.78A1.993 1.993 0 005 15a1.993 1.993 0 001-3.72V9.5l3-3V4.72A1.993 1.993 0 008 1zM2 4.2C1.34 4.2.8 3.65.8 3c0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2zm3 10c-.66 0-1.2-.55-1.2-1.2 0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2zm3-10c-.66 0-1.2-.55-1.2-1.2 0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2z\"/>"},"repo-template":{"width":14,"height":16,"path":"<path fill-rule=\"evenodd\" d=\"M12 8V1c0-.55-.45-1-1-1H1C.45 0 0 .45 0 1v12c0 .55.45 1 1 1h2v2l1.5-1.5L6 16v-4H3v1H1v-2h7v-1H2V1h9v7h1zM4 2H3v1h1V2zM3 4h1v1H3V4zm1 2H3v1h1V6zm0 3H3V8h1v1zm6 3H8v2h2v2h2v-2h2v-2h-2v-2h-2v2z\"/>"},"issue-opened":{"width":14,"height":16,"path":"<path fill-rule=\"evenodd\" d=\"M7 2.3c3.14 0 5.7 2.56 5.7 5.7s-2.56 5.7-5.7 5.7A5.71 5.71 0 011.3 8c0-3.14 2.56-5.7 5.7-5.7zM7 1C3.14 1 0 4.14 0 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7zm1 3H6v5h2V4zm0 6H6v2h2v-2z\"/>"},"cloud-download":{"width":16,"height":16,"path":"<path fill-rule=\"evenodd\" d=\"M9 12h2l-3 3-3-3h2V7h2v5zm3-8c0-.44-.91-3-4.5-3C5.08 1 3 2.92 3 5 1.02 5 0 6.52 0 8c0 1.53 1 3 3 3h3V9.7H3C1.38 9.7 1.3 8.28 1.3 8c0-.17.05-1.7 1.7-1.7h1.3V5c0-1.39 1.56-2.7 3.2-2.7 2.55 0 3.13 1.55 3.2 1.8v1.2H12c.81 0 2.7.22 2.7 2.2 0 2.09-2.25 2.2-2.7 2.2h-2V11h2c2.08 0 4-1.16 4-3.5C16 5.06 14.08 4 12 4z\"/>"}};

  var octicon = function (icon, height) {
    icon = ('' + icon).toLowerCase().replace(/^octicon-/, '');
    if (!hasOwnProperty(data, icon)) {
      icon = 'mark-github';
    }
    return '<svg viewBox="0 0 ' + data[icon].width + ' ' + data[icon].height + '" class="octicon octicon-' + icon + '" style="width: ' + (height * data[icon].width / data[icon].height) + 'px; height: ' + height + 'px;" aria-hidden="true">' + data[icon].path + '</svg>'
  };

  var queues = {};

  var fetch = function (url, func) {
    var queue = queues[url] || (queues[url] = []);
    if (queue.push(func) > 1) {
      return
    }

    var callback = dispatchOnce(function () {
      delete queues[url];
      while ((func = queue.shift())) {
        func.apply(null, arguments);
      }
    });

    if (useXHR) {
      var xhr = new XMLHttpRequest();
      onEvent(xhr, 'abort', callback);
      onEvent(xhr, 'error', callback);
      onEvent(xhr, 'load', function () {
        var data;
        try {
          data = JSON.parse(xhr.responseText);
        } catch (error) {
          callback(error);
          return
        }
        callback(xhr.status !== 200, data);
      });
      xhr.open('GET', url);
      xhr.send();
    } else {
      var contentWindow = this || window;
      contentWindow._ = function (json) {
        contentWindow._ = null;
        callback(json.meta.status !== 200, json.data);
      };
      var script = createElementInDocument(contentWindow.document)('script', {
        async: true,
        src: url + (/\?/.test(url) ? '&' : '?') + 'callback=_'
      });
      var onloadend = /* istanbul ignore next: IE lt 9 */ function () {
        if (contentWindow._) {
          contentWindow._({
            meta: {}
          });
        }
      };
      onEvent(script, 'load', onloadend);
      onEvent(script, 'error', onloadend);
      /* istanbul ignore if: IE lt 9 */
      if (script.readyState) {
        onceReadyStateChange(script, /de|m/, onloadend);
      }
      contentWindow.document.getElementsByTagName('head')[0].appendChild(script);
    }
  };

  var render = function (root, options, func) {
    var createElement = createElementInDocument(root.ownerDocument);

    var style = root.appendChild(createElement('style', {
      type: 'text/css'
    }));

    var cssText = buttonsCssText + getColorScheme(options['data-color-scheme']);

    /* istanbul ignore if: IE lt 9 */
    if (style.styleSheet) {
      style.styleSheet.cssText = cssText;
    } else {
      style.appendChild(root.ownerDocument.createTextNode(cssText));
    }

    var btn = createElement('a', {
      className: 'btn',
      href: options.href,
      target: '_blank',
      rel: 'noopener',
      innerHTML: octicon(options['data-icon'], /^large$/i.test(options['data-size']) ? 16 : 14),
      'aria-label': options['aria-label'] || undefined
    }, [
      ' ',
      createElement('span', {}, [options['data-text'] || ''])
    ]);

    var widget = root.appendChild(createElement('div', {
      className: 'widget' + (/^large$/i.test(options['data-size']) ? ' widget-lg' : '')
    }, [
      btn
    ]));

    var domain = btn.hostname.split('.').reverse();
    if (domain[0] === '') {
      domain.shift();
    }
    if (domain[0] !== 'com' || domain[1] !== 'github') {
      btn.href = '#';
      btn.target = '_self';
      func(widget);
      return
    }

    var len = domain.length;
    var path = (' /' + btn.pathname).split(/\/+/);
    if (((len === 2 || (len === 3 && domain[2] === 'gist')) && path[3] === 'archive') ||
      (len === 2 && path[3] === 'releases' && path[4] === 'download') ||
      (len === 3 && domain[2] === 'codeload')) {
      btn.target = '_top';
    }

    if (!/^true$/i.test(options['data-show-count']) || len !== 2) {
      func(widget);
      return
    }

    var href, property;
    if (!path[2] && path[1]) {
      href = property = 'followers';
    } else if (!path[3] && path[2]) {
      property = 'stargazers_count';
      href = 'stargazers';
    } else if (!path[4] && path[3] === 'subscription') {
      property = 'subscribers_count';
      href = 'watchers';
    } else if (!path[4] && path[3] === 'fork') {
      property = 'forks_count';
      href = 'network/members';
    } else if (path[3] === 'issues') {
      property = 'open_issues_count';
      href = 'issues';
    } else {
      func(widget);
      return
    }

    var api = path[2] ? '/repos/' + path[1] + '/' + path[2] : '/users/' + path[1];
    fetch.call(this, apiBaseURL + api, function (error, json) {
      if (!error) {
        var data = json[property];
        widget.appendChild(createElement('a', {
          className: 'social-count',
          href: json.html_url + '/' + href,
          target: '_blank',
          rel: 'noopener',
          'aria-label': data + ' ' + property.replace(/_count$/, '').replace('_', ' ').slice(0, data < 2 ? -1 : undefined) + ' on GitHub'
        }, [
          ('' + data).replace(/\B(?=(\d{3})+(?!\d))/g, ',')
        ]));
      }
      func(widget);
    });
  };

  var parseOptions = function (anchor) {
    var options = {
      href: anchor.href,
      title: anchor.title,
      'aria-label': anchor.getAttribute('aria-label')
    };
    var ref = ['icon', 'color-scheme', 'text', 'size', 'show-count'];
    for (var i = 0, len = ref.length; i < len; i++) {
      var attribute = 'data-' + ref[i];
      options[attribute] = anchor.getAttribute(attribute);
    }
    if (options['data-text'] == null) {
      options['data-text'] = anchor.textContent || anchor.innerText;
    }
    return options
  };

  var devicePixelRatio = window.devicePixelRatio || /* istanbul ignore next */ 1;

  var ceilPixel = function (px) {
    return (devicePixelRatio > 1 ? Math.ceil(Math.round(px * devicePixelRatio) / devicePixelRatio * 2) / 2 : Math.ceil(px)) || 0
  };

  var get = function (el) {
    var width = el.offsetWidth;
    var height = el.offsetHeight;
    if (el.getBoundingClientRect) {
      var boundingClientRect = el.getBoundingClientRect();
      width = Math.max(width, ceilPixel(boundingClientRect.width));
      height = Math.max(height, ceilPixel(boundingClientRect.height));
    }
    return [width, height]
  };

  var set = function (el, size) {
    el.style.width = size[0] + 'px';
    el.style.height = size[1] + 'px';
  };

  var render$1 = function (options, func) {
    if (options == null || func == null) {
      return
    }
    if (options.getAttribute) {
      options = parseOptions(options);
    }
    if (useShadowDOM) {
      var host = createElement('span', {
        title: options.title || undefined
      });
      render(host.attachShadow({ mode:  'closed' }), options, function () {
        func(host);
      });
    } else {
      var iframe = createElement('iframe', {
        src: 'javascript:0',
        title: options.title || undefined,
        allowtransparency: true,
        scrolling: 'no',
        frameBorder: 0
      });
      set(iframe, [0, 0]);
      iframe.style.border = 'none';
      var callback = function () {
        var contentWindow = iframe.contentWindow;
        var body;
        try {
          body = contentWindow.document.body;
        } catch (_) /* istanbul ignore next: IE 11 */ {
          document.body.appendChild(iframe.parentNode.removeChild(iframe));
          return
        }
        offEvent(iframe, 'load', callback);
        render.call(contentWindow, body, options, function (widget) {
          var size = get(widget);
          iframe.parentNode.removeChild(iframe);
          onceEvent(iframe, 'load', function () {
            set(iframe, size);
          });
          iframe.src = iframeURL + '#' + (iframe.name = stringify(options));
          func(iframe);
        });
      };
      onEvent(iframe, 'load', callback);
      document.body.appendChild(iframe);
    }
  };

  if (location.protocol + '//' + location.host + location.pathname === iframeURL) {
    render(document.body, parse(window.name || location.hash.replace(/^#/, '')), function () {});
  } else {
    defer(function () {
      var ref = document.querySelectorAll
        ? document.querySelectorAll('a.' + buttonClass)
        : (function () {
          var results = [];
          var ref = document.getElementsByTagName('a');
          for (var i = 0, len = ref.length; i < len; i++) {
            if (~(' ' + ref[i].className + ' ').replace(/[ \t\n\f\r]+/g, ' ').indexOf(' ' + buttonClass + ' ')) {
              results.push(ref[i]);
            }
          }
          return results
        })();
      for (var i = 0, len = ref.length; i < len; i++) {
        (function (anchor) {
          render$1(anchor, function (el) {
            anchor.parentNode.replaceChild(el, anchor);
          });
        })(ref[i]);
      }
    });
  }

}());
