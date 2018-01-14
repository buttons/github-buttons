(function () {
'use strict';

var document = window.document;

var encodeURIComponent = window.encodeURIComponent;

var decodeURIComponent = window.decodeURIComponent;

var Math = window.Math;

var createElement = function(tag) {
  return document.createElement(tag);
};

var baseURL;
var buttonClass;
var setBaseURL;
var uuid;

buttonClass = "github-button";

uuid = "faa75404-3b97-5585-b449-4bc51338fbd1";


/* istanbul ignore next */

baseURL = (/^http:/.test(document.location) ? "http" : "https") + "://buttons.github.io/";

setBaseURL = function(url) {
  baseURL = url;
};

var currentScript;
var currentScriptURL;

currentScript = "currentScript";


/* istanbul ignore next */

currentScriptURL = !{}.hasOwnProperty.call(document, currentScript) && document[currentScript] && delete document[currentScript] && document[currentScript] ? document[currentScript].src : void 0;

var stringifyQueryString = function(obj) {
  var name, params, value;
  params = [];
  for (name in obj) {
    value = obj[name];
    if (value != null) {
      params.push((encodeURIComponent(name)) + "=" + (encodeURIComponent(value)));
    }
  }
  return params.join("&");
};

var onEvent;
var onceEvent;

onEvent = function(target, eventName, func) {

  /* istanbul ignore else: IE lt 9 */
  if (target.addEventListener) {
    target.addEventListener("" + eventName, func);
  } else {
    target.attachEvent("on" + eventName, func);
  }
};

onceEvent = function(target, eventName, func) {
  var callback;
  callback = function(event) {

    /* istanbul ignore else: IE lt 9 */
    if (target.removeEventListener) {
      target.removeEventListener("" + eventName, callback);
    } else {
      target.detachEvent("on" + eventName, callback);
    }
    return func(event);
  };
  onEvent(target, eventName, callback);
};

var defer;

/* istanbul ignore next */

defer = function(func) {
  var callback, onceToken;
  if (/m/.test(document.readyState) || (!/g/.test(document.readyState) && !document.documentElement.doScroll)) {
    setTimeout(func);
  } else {
    if (document.addEventListener) {
      onceToken = 0;
      callback = function() {
        if (!onceToken && (onceToken = 1)) {
          func();
        }
      };
      onceEvent(document, "DOMContentLoaded", callback);
      onceEvent(window, "load", callback);
    } else {
      callback = function() {
        if (/m/.test(document.readyState)) {
          document.detachEvent("onreadystatechange", callback);
          func();
        }
      };
      document.attachEvent("onreadystatechange", callback);
    }
  }
};

var ceilPixel = function(px) {
  var devicePixelRatio;
  devicePixelRatio = window.devicePixelRatio || 1;
  return (devicePixelRatio > 1 ? Math.ceil(Math.round(px * devicePixelRatio) / devicePixelRatio * 2) / 2 : Math.ceil(px)) || 0;
};

var getFrameContentSize;
var setFrameSize;

getFrameContentSize = function(iframe) {
  var body, boundingClientRect, contentDocument, display, height, html, width;
  contentDocument = iframe.contentWindow.document;
  html = contentDocument.documentElement;
  body = contentDocument.body;
  width = html.scrollWidth;
  height = html.scrollHeight;
  if (body.getBoundingClientRect) {
    display = body.style.display;
    body.style.display = "inline-block";
    boundingClientRect = body.getBoundingClientRect();
    width = Math.max(width, ceilPixel(boundingClientRect.width || boundingClientRect.right - boundingClientRect.left));
    height = Math.max(height, ceilPixel(boundingClientRect.height || boundingClientRect.bottom - boundingClientRect.top));
    body.style.display = display;
  }
  return [width, height];
};

setFrameSize = function(iframe, size) {
  iframe.style.width = size[0] + "px";
  iframe.style.height = size[1] + "px";
};

var parseOptions = function(anchor) {
  var attribute, deprecate, i, len, options, ref;
  options = {
    "href": anchor.href,
    "aria-label": anchor.getAttribute("aria-label")
  };
  ref = ["icon", "text", "size", "show-count"];
  for (i = 0, len = ref.length; i < len; i++) {
    attribute = ref[i];
    attribute = "data-" + attribute;
    options[attribute] = anchor.getAttribute(attribute);
  }
  if (options["data-text"] == null) {
    options["data-text"] = anchor.textContent || anchor.innerText;
  }
  deprecate = function(oldAttribute, newAttribute, newValue) {
    if (anchor.getAttribute(oldAttribute)) {
      options[newAttribute] = newValue;
      window.console && console.warn("GitHub Buttons deprecated `" + oldAttribute + "`: use `" + newAttribute + "=\"" + newValue + "\"` instead. Please refer to https://github.com/ntkme/github-buttons#readme for more info.");
    }
  };
  deprecate("data-count-api", "data-show-count", "true");
  deprecate("data-style", "data-size", "large");
  return options;
};

var render;

/* istanbul ignore next */

render = function(targetNode, options) {
  var contentDocument, hash, iframe, name, onload, ref, value;
  if (targetNode == null) {
    return renderAll();
  }
  if (options == null) {
    options = parseOptions(targetNode);
  }
  hash = "#" + stringifyQueryString(options);
  iframe = createElement("iframe");
  ref = {
    allowtransparency: true,
    scrolling: "no",
    frameBorder: 0
  };
  for (name in ref) {
    value = ref[name];
    iframe.setAttribute(name, value);
  }
  setFrameSize(iframe, [1, 0]);
  iframe.style.border = "none";
  iframe.src = "javascript:0";
  document.body.appendChild(iframe);
  onload = function() {
    var size;
    size = getFrameContentSize(iframe);
    iframe.parentNode.removeChild(iframe);
    onceEvent(iframe, "load", function() {
      setFrameSize(iframe, size);
    });
    iframe.src = baseURL + "buttons.html" + hash;
    targetNode.parentNode.replaceChild(iframe, targetNode);
  };
  onceEvent(iframe, "load", function() {
    var contentWindow;
    contentWindow = iframe.contentWindow;
    if (contentWindow.$) {
      contentWindow.$ = onload;
    } else {
      onload();
    }
  });
  contentDocument = iframe.contentWindow.document;
  contentDocument.open().write("<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title>" + uuid + "</title><link rel=\"stylesheet\" href=\"" + baseURL + "assets/css/buttons.css\"><script>document.location.hash = \"" + hash + "\";</script></head><body><script src=\"" + baseURL + "buttons.js\"></script></body></html>");
  contentDocument.close();
};

var renderAll;

/* istanbul ignore next */

renderAll = function() {
  var anchor, anchors, i, j, len, len1, ref;
  anchors = [];
  if (document.querySelectorAll) {
    anchors = document.querySelectorAll("a." + buttonClass);
  } else {
    ref = document.getElementsByTagName("a");
    for (i = 0, len = ref.length; i < len; i++) {
      anchor = ref[i];
      if (~(" " + anchor.className + " ").replace(/[ \t\n\f\r]+/g, " ").indexOf(" " + buttonClass + " ")) {
        anchors.push(anchor);
      }
    }
  }
  for (j = 0, len1 = anchors.length; j < len1; j++) {
    anchor = anchors[j];
    render(anchor);
  }
};

if (currentScriptURL) {
  setBaseURL(currentScriptURL.replace(/[^\/]*\/[^\/]*\/[^\/]*([?#].*)?$/, ''));
}

window.onbeforeunload = function() {};

defer(function() {
  Vue.component('github-button-preview', {
    template: '#github-button-preview-template',
    props: ['config'],
    data: function() {
      return {
        timeoutId: null
      };
    },
    computed: {
      rateLimitWait: function() {
        if (this.config['data-show-count']) {
          return 300;
        } else {
          return 0;
        }
      }
    },
    mounted: function() {
      var iframe, onload;
      iframe = this.$el.firstChild;
      onload = function() {
        setFrameSize(iframe, getFrameContentSize(iframe));
      };
      onEvent(iframe, 'load', function() {
        var contentWindow;
        contentWindow = iframe.contentWindow;
        if (contentWindow.$) {
          contentWindow.$ = onload;
        } else {
          onload();
        }
      });
      this.update();
    },
    updated: function() {
      this.update();
    },
    methods: {
      update: function() {
        var iframe;
        iframe = this.$el.firstChild;
        setFrameSize(iframe, [1, 0]);
        clearTimeout(this.timeoutId);
        this.timeoutId = setTimeout((function(_this) {
          return function() {
            iframe = _this.$el.removeChild(iframe);
            iframe.src = 'buttons.html#' + stringifyQueryString(_this.config);
            _this.$el.appendChild(iframe);
          };
        })(this), this.rateLimitWait);
      }
    }
  });
  Vue.component('github-button-code', {
    template: '#github-button-code-template',
    props: ['text']
  });
  new Vue({
    el: '#app',
    template: '#app-template',
    mounted: function() {
      setTimeout(renderAll);
    },
    data: function() {
      return {
        script: '<!-- Place this tag in your head or just before your close body tag. -->\n<script async defer src="https://buttons.github.io/buttons.js"></script>',
        options: {
          type: null,
          user: '',
          repo: '',
          largeButton: false,
          showCount: false,
          standardIcon: false
        }
      };
    },
    watch: {
      'options.type': function() {
        this.$nextTick(function() {
          if (document.activeElement !== this.$refs.user && document.activeElement !== this.$refs.repo) {
            if (this.options.type === 'follow' || !this.successes.user || (this.successes.user && this.successes.repo)) {
              this.$refs.user.focus();
            } else {
              this.$refs.repo.focus();
            }
          }
        });
      }
    },
    computed: {
      code: function() {
        var a, name, ref, value;
        a = createElement('a');
        a.className = 'github-button';
        a.href = this.config.href;
        a.textContent = this.config['data-text'];
        ref = this.config;
        for (name in ref) {
          value = ref[name];
          if (name !== 'href' && name !== 'data-text' && (value != null)) {
            a.setAttribute(name, value);
          }
        }
        return '<!-- Place this tag where you want the button to render. -->\n' + a.outerHTML;
      },
      successes: function() {
        return {
          user: (function(user) {
            return 0 < user.length && user.length < 40 && !/[^A-Za-z0-9-]|^-|-$|--/i.test(user);
          })(this.options.user),
          repo: (function(repo) {
            return 0 < repo.length && repo.length < 101 && !/[^\w-.]|\.git$|^\.\.?$/i.test(repo);
          })(this.options.repo)
        };
      },
      hasSuccess: function() {
        if (this.options.type === 'follow') {
          return this.successes.user;
        } else {
          return this.successes.user && this.successes.repo;
        }
      },
      dangers: function() {
        return {
          user: this.options.user !== '' && !this.successes.user,
          repo: this.options.type !== 'follow' && this.options.repo !== '' && !this.successes.repo
        };
      },
      hasDanger: function() {
        return this.dangers.user || this.dangers.repo;
      },
      config: function() {
        var options;
        if (this.options.type == null) {
          return;
        }
        options = {
          type: this.options.type,
          user: this.hasSuccess ? this.options.user : 'ntkme',
          repo: this.hasSuccess ? this.options.repo : 'github-buttons',
          largeButton: this.options.largeButton,
          showCount: this.options.showCount,
          standardIcon: this.options.standardIcon
        };
        return {
          href: (function() {
            var base, repo, user;
            base = 'https://github.com';
            user = '/' + options.user;
            repo = user + '/' + options.repo;
            switch (options.type) {
              case 'follow':
                return base + user;
              case 'watch':
                return base + repo + '/subscription';
              case 'star':
                return base + repo;
              case 'fork':
                return base + repo + '/fork';
              case 'issue':
                return base + repo + '/issues';
              case 'download':
                return base + repo + '/archive/master.zip';
              default:
                return base;
            }
          })(),
          'data-text': (function() {
            switch (options.type) {
              case 'follow':
                return 'Follow @' + options.user;
              default:
                return options.type.charAt(0).toUpperCase() + options.type.slice(1).toLowerCase();
            }
          })(),
          'data-icon': (function() {
            if (options.standardIcon) {
              return;
            }
            switch (options.type) {
              case 'watch':
                return 'octicon-eye';
              case 'star':
                return 'octicon-star';
              case 'fork':
                return 'octicon-repo-forked';
              case 'issue':
                return 'octicon-issue-opened';
              case 'download':
                return 'octicon-cloud-download';
            }
          })(),
          'data-size': (function() {
            if (options.largeButton) {
              return 'large';
            } else {
              return null;
            }
          })(),
          'data-show-count': (function() {
            if (options.showCount) {
              switch (options.type) {
                case 'download':
                  return null;
                default:
                  return true;
              }
            }
            return null;
          })(),
          'aria-label': (function() {
            switch (options.type) {
              case 'follow':
                return 'Follow @' + options.user + ' on GitHub';
              case 'watch':
              case 'star':
              case 'fork':
              case 'issue':
              case 'download':
                return (options.type.charAt(0).toUpperCase() + options.type.slice(1).toLowerCase()) + ' ' + options.user + '/' + options.repo + ' on GitHub';
              default:
                return 'GitHub';
            }
          })()
        };
      }
    },
    methods: {
      onPaste: function() {
        this.$nextTick(function() {
          var ref, repo, user;
          ref = this.options.user.replace(/^\s+/g, '').replace(/\/+/, '/').replace(/^\//, '').split('/'), user = ref[0], repo = ref[1];
          this.options.user = user;
          if (repo != null) {
            this.options.repo = repo;
            if (this.options.user !== '') {
              this.$refs.repo.focus();
              this.$refs.repo.selectionStart = this.$refs.repo.selectionEnd = this.options.repo.length;
            }
          }
        });
      }
    }
  });
});

}());
