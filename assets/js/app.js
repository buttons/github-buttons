(function () {
  'use strict';

  var document = window.document;

  var encodeURIComponent = window.encodeURIComponent;

  var decodeURIComponent = window.decodeURIComponent;

  var Math = window.Math;

  var createElement = function(tag) {
    return document.createElement(tag);
  };

  var createTextNode = function(text) {
    return document.createTextNode(text);
  };

  var apiBaseURL, baseURL, buttonClass, setBaseURL, uuid;

  buttonClass = "github-button";

  uuid = "faa75404-3b97-5585-b449-4bc51338fbd1";


  /* istanbul ignore next */

  baseURL = (/^http:/.test(document.location) ? "http" : "https") + "://buttons.github.io/";

  apiBaseURL = "https://api.github.com/";

  setBaseURL = function(url) {
    baseURL = url;
  };

  var currentScript, currentScriptURL;

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

  var onEvent, onceEvent;

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

  var ceilPixel, devicePixelRatio;


  /* istanbul ignore next */

  devicePixelRatio = window.devicePixelRatio || 1;

  ceilPixel = function(px) {
    return (devicePixelRatio > 1 ? Math.ceil(Math.round(px * devicePixelRatio) / devicePixelRatio * 2) / 2 : Math.ceil(px)) || 0;
  };

  var getFrameContentSize, setFrameSize;

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
    var attribute, i, len, options, ref;
    options = {
      "href": anchor.href,
      "title": anchor.title,
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
    return options;
  };

  var data = {"mark-github":{"width":16,"height":16,"path":"<path fill-rule=\"evenodd\" d=\"M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 2.2 0 .21.15.46.55.38A8.013 8.013 0 0 0 16 8c0-4.42-3.58-8-8-8z\"/>"},"eye":{"width":16,"height":16,"path":"<path fill-rule=\"evenodd\" d=\"M8.06 2C3 2 0 8 0 8s3 6 8.06 6C13 14 16 8 16 8s-3-6-7.94-6zM8 12c-2.2 0-4-1.78-4-4 0-2.2 1.8-4 4-4 2.22 0 4 1.8 4 4 0 2.22-1.78 4-4 4zm2-4c0 1.11-.89 2-2 2-1.11 0-2-.89-2-2 0-1.11.89-2 2-2 1.11 0 2 .89 2 2z\"/>"},"star":{"width":14,"height":16,"path":"<path fill-rule=\"evenodd\" d=\"M14 6l-4.9-.64L7 1 4.9 5.36 0 6l3.6 3.26L2.67 14 7 11.67 11.33 14l-.93-4.74L14 6z\"/>"},"repo-forked":{"width":10,"height":16,"path":"<path fill-rule=\"evenodd\" d=\"M8 1a1.993 1.993 0 0 0-1 3.72V6L5 8 3 6V4.72A1.993 1.993 0 0 0 2 1a1.993 1.993 0 0 0-1 3.72V6.5l3 3v1.78A1.993 1.993 0 0 0 5 15a1.993 1.993 0 0 0 1-3.72V9.5l3-3V4.72A1.993 1.993 0 0 0 8 1zM2 4.2C1.34 4.2.8 3.65.8 3c0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2zm3 10c-.66 0-1.2-.55-1.2-1.2 0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2zm3-10c-.66 0-1.2-.55-1.2-1.2 0-.65.55-1.2 1.2-1.2.65 0 1.2.55 1.2 1.2 0 .65-.55 1.2-1.2 1.2z\"/>"},"issue-opened":{"width":14,"height":16,"path":"<path fill-rule=\"evenodd\" d=\"M7 2.3c3.14 0 5.7 2.56 5.7 5.7s-2.56 5.7-5.7 5.7A5.71 5.71 0 0 1 1.3 8c0-3.14 2.56-5.7 5.7-5.7zM7 1C3.14 1 0 4.14 0 8s3.14 7 7 7 7-3.14 7-7-3.14-7-7-7zm1 3H6v5h2V4zm0 6H6v2h2v-2z\"/>"},"cloud-download":{"width":16,"height":16,"path":"<path fill-rule=\"evenodd\" d=\"M9 12h2l-3 3-3-3h2V7h2v5zm3-8c0-.44-.91-3-4.5-3C5.08 1 3 2.92 3 5 1.02 5 0 6.52 0 8c0 1.53 1 3 3 3h3V9.7H3C1.38 9.7 1.3 8.28 1.3 8c0-.17.05-1.7 1.7-1.7h1.3V5c0-1.39 1.56-2.7 3.2-2.7 2.55 0 3.13 1.55 3.2 1.8v1.2H12c.81 0 2.7.22 2.7 2.2 0 2.09-2.25 2.2-2.7 2.2h-2V11h2c2.08 0 4-1.16 4-3.5C16 5.06 14.08 4 12 4z\"/>"}};

  var octicon;

  octicon = function(icon, height) {
    var width;
    icon = ("" + icon).toLowerCase().replace(/^octicon-/, "");
    if (!data.hasOwnProperty(icon)) {
      icon = "mark-github";
    }
    width = height * data[icon].width / data[icon].height;
    return "<svg version=\"1.1\" width=\"" + width + "\" height=\"" + height + "\" viewBox=\"0 0 " + data[icon].width + " " + data[icon].height + "\" class=\"octicon octicon-" + icon + "\" aria-hidden=\"true\">" + data[icon].path + "</svg>";
  };

  var render;

  render = function(root, options) {
    var a, ariaLabel, span;
    a = createElement("a");
    a.href = options.href;
    a.target = "_blank";
    if (!/\.github\.com$/.test("." + a.hostname)) {
      a.href = "#";
      a.target = "_self";
    } else if (/^https?:\/\/((gist\.)?github\.com\/[^\/?#]+\/[^\/?#]+\/archive\/|github\.com\/[^\/?#]+\/[^\/?#]+\/releases\/download\/|codeload\.github\.com\/)/.test(a.href)) {
      a.target = "_top";
    }
    a.className = "btn";
    if (ariaLabel = options["aria-label"]) {
      a.setAttribute("aria-label", ariaLabel);
    }
    a.innerHTML = octicon(options["data-icon"], /^large$/i.test(options["data-size"]) ? 16 : 14);
    a.appendChild(createTextNode(" "));
    span = a.appendChild(createElement("span"));
    span.appendChild(createTextNode(options["data-text"] || ""));
    return root.appendChild(a);
  };

  var fetch;

  fetch = function(url, func, hook) {
    var callback, head, onceToken, onloadend, script, xhr;
    if (hook) {
      window[hook] = function() {
        window[hook] = null;
      };
    }
    onceToken = 0;
    callback = function() {
      if (!onceToken && (onceToken = 1)) {
        func.apply(null, arguments);
        if (hook) {
          window[hook]();
        }
      }
    };
    if (window.XMLHttpRequest && "withCredentials" in XMLHttpRequest.prototype) {
      xhr = new XMLHttpRequest();
      onEvent(xhr, "abort", callback);
      onEvent(xhr, "error", callback);
      onEvent(xhr, "load", function() {
        callback(xhr.status !== 200, JSON.parse(xhr.responseText));
      });
      xhr.open("GET", url);
      xhr.send();
    } else {
      window._ = function(json) {
        window._ = null;
        callback(json.meta.status !== 200, json.data);
      };
      script = createElement("script");
      script.async = true;
      script.src = url + (/\?/.test(url) ? "&" : "?") + "callback=_";
      onloadend = function() {
        if (window._) {
          _({
            meta: {}
          });
        }
      };
      onEvent(script, "error", onloadend);
      if (script.readyState) {

        /* istanbul ignore next: IE lt 9 */
        onEvent(script, "readystatechange", function() {
          if (script.readyState === "loaded") {
            onloadend();
          }
        });
      }
      head = document.getElementsByTagName("head")[0];

      /* istanbul ignore if: Presto based Opera */
      if ("[object Opera]" === {}.toString.call(window.opera)) {
        defer(function() {
          head.appendChild(script);
        });
      } else {
        head.appendChild(script);
      }
    }
  };

  var render$1;

  render$1 = function(button) {
    var api, hook, href, match, property;
    if (button.hostname !== "github.com") {
      return;
    }
    match = button.pathname.replace(/^(?!\/)/, "/").match(/^\/([^\/?#]+)(?:\/([^\/?#]+)(?:\/(?:(subscription)|(fork)|(issues)|([^\/?#]+)))?)?(?:[\/?#]|$)/);
    if (!(match && !match[6])) {
      return;
    }
    if (match[2]) {
      api = "repos/" + match[1] + "/" + match[2];
      if (match[3]) {
        property = "subscribers_count";
        href = "watchers";
      } else if (match[4]) {
        property = "forks_count";
        href = "network";
      } else if (match[5]) {
        property = "open_issues_count";
        href = "issues";
      } else {
        property = "stargazers_count";
        href = "stargazers";
      }
    } else {
      api = "users/" + match[1];
      href = property = "followers";
    }

    /* istanbul ignore if */
    if (!HTMLElement.prototype.attachShadow) {
      hook = "$";
    }
    fetch(apiBaseURL + api, function(error, json) {
      var a, data, span;
      if (!error) {
        data = json[property];
        a = createElement("a");
        a.href = json.html_url + "/" + href;
        a.target = "_blank";
        a.className = "social-count";
        a.setAttribute("aria-label", data + " " + (property.replace(/_count$/, "").replace("_", " ")) + " on GitHub");
        a.appendChild(createElement("b"));
        a.appendChild(createElement("i"));
        span = a.appendChild(createElement("span"));
        span.appendChild(createTextNode(("" + data).replace(/\B(?=(\d{3})+(?!\d))/g, ",")));
        button.parentNode.insertBefore(a, button.nextSibling);
      }
    }, hook);
  };

  var render$2;

  render$2 = function(root, options) {
    var button;
    if (!options) {
      return;
    }
    if (/^large$/i.test(options["data-size"])) {
      root.className = "large";
    }
    button = render(root, options);
    if (/^(true|1)$/i.test(options["data-show-count"])) {
      render$1(button);
    }
  };

  var render$3;


  /* istanbul ignore next */

  render$3 = function(targetNode, options) {
    var contentDocument, hash, host, iframe, link, name, onload, ref, root, title, value;
    if (targetNode == null) {
      return render$4();
    }
    if (options == null) {
      options = parseOptions(targetNode);
    }
    if (HTMLElement.prototype.attachShadow) {
      host = createElement("span");
      if (title = options.title) {
        host.title = title;
      }
      root = host.attachShadow({
        mode: "closed"
      });
      link = createElement("link");
      link.rel = "stylesheet";
      link.href = baseURL + "assets/css/buttons.css";
      root.appendChild(link);
      render$2(root.appendChild(createElement("span")), options);
      targetNode.parentNode.replaceChild(host, targetNode);
    } else {
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
      if (title = options.title) {
        iframe.title = title;
      }
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
    }
  };

  var render$4;


  /* istanbul ignore next */

  render$4 = function() {
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
      render$3(anchor);
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
        setTimeout(render$4);
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
