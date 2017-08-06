var document = window.document;

var encodeURIComponent = window.encodeURIComponent;



var Math = window.Math;

var createElement = function(tag) {
  return document.createElement(tag);
};

var createTextNode = function(text) {
  return document.createTextNode(text);
};

var baseURL;
var buttonClass;
var currentScript;
var currentScriptURL;
var iconBaseClass;
var iconClass;
var setBaseURL;
var uuid;

buttonClass = "github-button";

iconBaseClass = "octicon";

iconClass = iconBaseClass + "-mark-github";

uuid = "faa75404-3b97-5585-b449-4bc51338fbd1";


/* istanbul ignore next */

baseURL = (/^http:/.test(document.location) ? "http" : "https") + "://buttons.github.io/";

setBaseURL = function(url) {
  baseURL = url;
};

currentScript = "currentScript";


/* istanbul ignore next */

currentScriptURL = !{}.hasOwnProperty.call(document, currentScript) && document[currentScript] && delete document[currentScript] && document[currentScript] ? document[currentScript].src : void 0;

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
      window.console && window.console.warn("GitHub Buttons deprecated `" + oldAttribute + "`: use `" + newAttribute + "=\"" + newValue + "\"` instead. Please refer to https://github.com/ntkme/github-buttons#readme for more info.");
    }
  };
  deprecate("data-count-api", "data-show-count", "true");
  deprecate("data-style", "data-size", "large");
  return options;
};

var onEvent;
var onceEvent;
var onceScriptLoad;

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

onceScriptLoad = function(script, func) {
  var callback, token;
  token = 0;
  callback = function() {
    if (!token && (token = 1)) {
      func();
    }
  };
  onEvent(script, "load", callback);
  onEvent(script, "error", callback);

  /* istanbul ignore next: IE lt 9 */
  onEvent(script, "readystatechange", function() {
    if (!/i/.test(script.readyState)) {
      callback();
    }
  });
};

var defer;

/* istanbul ignore next */

defer = function(func) {
  var callback, token;
  if (/m/.test(document.readyState) || (!/g/.test(document.readyState) && !document.documentElement.doScroll)) {
    window.setTimeout(func);
  } else {
    if (document.addEventListener) {
      token = 0;
      callback = function() {
        if (!token && (token = 1)) {
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

var jsonp;

jsonp = function(url, func) {
  var head, script;
  script = createElement("script");
  script.async = true;
  script.src = url + (/\?/.test(url) ? "&" : "?") + "callback=_";
  window._ = function(json) {
    window._ = null;
    func(json);
  };
  window._.$ = script;
  onEvent(script, "error", function() {
    window._ = null;
  });
  if (script.readyState) {

    /* istanbul ignore next: IE lt 9 */
    onEvent(script, "readystatechange", function() {
      if (script.readyState === "loaded" && script.children && script.readyState === "loading") {
        window._ = null;
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
};

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

var ceilPixel = function(px) {
  var devicePixelRatio;
  devicePixelRatio = window.devicePixelRatio || 1;
  return (devicePixelRatio > 1 ? Math.ceil(Math.round(px * devicePixelRatio) / devicePixelRatio * 2) / 2 : Math.ceil(px)) || 0;
};

var getFrameContentSize;
var setFrameSize;

getFrameContentSize = function(iframe) {
  var body, boundingClientRect, contentDocument, height, html, width;
  contentDocument = iframe.contentWindow.document;
  html = contentDocument.documentElement;
  body = contentDocument.body;
  width = html.scrollWidth;
  height = html.scrollHeight;
  if (body.getBoundingClientRect) {
    body.style.display = "inline-block";
    boundingClientRect = body.getBoundingClientRect();
    width = Math.max(width, ceilPixel(boundingClientRect.width || boundingClientRect.right - boundingClientRect.left));
    height = Math.max(height, ceilPixel(boundingClientRect.height || boundingClientRect.bottom - boundingClientRect.top));
    body.style.display = "";
  }
  return [width, height];
};

setFrameSize = function(iframe, size) {
  iframe.style.width = size[0] + "px";
  iframe.style.height = size[1] + "px";
};

var render;
var renderAll;
var renderButton;
var renderCount;
var renderFrameContent;

renderButton = function(options) {
  var a, ariaLabel, i, span;
  a = createElement("a");
  a.href = options.href;
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
  i = a.appendChild(createElement("i"));
  i.className = iconBaseClass + " " + (options["data-icon"] || iconClass);
  i.setAttribute("aria-hidden", "true");
  a.appendChild(createTextNode(" "));
  span = a.appendChild(createElement("span"));
  span.appendChild(createTextNode(options["data-text"] || ""));
  return document.body.appendChild(a);
};

renderCount = function(button) {
  var api, href, match, property;
  if (button.hostname !== "github.com") {
    return;
  }
  match = button.pathname.replace(/^(?!\/)/, "/").match(/^\/([^\/?#]+)(?:\/([^\/?#]+)(?:\/(?:(subscription)|(fork)|(issues)|([^\/?#]+)))?)?(?:[\/?#]|$)/);
  if (!(match && !match[6])) {
    return;
  }
  if (match[2]) {
    href = "/" + match[1] + "/" + match[2];
    api = "/repos" + href;
    if (match[3]) {
      property = "subscribers_count";
      href += "/watchers";
    } else if (match[4]) {
      property = "forks_count";
      href += "/network";
    } else if (match[5]) {
      property = "open_issues_count";
      href += "/issues";
    } else {
      property = "stargazers_count";
      href += "/stargazers";
    }
  } else {
    api = "/users/" + match[1];
    property = "followers";
    href = "/" + match[1] + "/" + property;
  }
  jsonp("https://api.github.com" + api, function(json) {
    var a, data, span;
    if (json.meta.status === 200) {
      data = json.data[property];
      a = createElement("a");
      a.href = "https://github.com" + href;
      a.className = "social-count";
      a.setAttribute("aria-label", data + " " + (property.replace(/_count$/, "").replace("_", " ")) + " on GitHub");
      a.appendChild(createElement("b"));
      a.appendChild(createElement("i"));
      span = a.appendChild(createElement("span"));
      span.appendChild(createTextNode(("" + data).replace(/\B(?=(\d{3})+(?!\d))/g, ",")));
      button.parentNode.insertBefore(a, button.nextSibling);
    }
  });
};

renderFrameContent = function(options) {
  var button;
  if (!options) {
    return;
  }
  if (/^large$/i.test(options["data-size"])) {
    document.body.className = "large";
  }
  button = renderButton(options);
  if (/^(true|1)$/i.test(options["data-show-count"])) {
    renderCount(button);
  }
};


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
    var callback;
    if (callback = iframe.contentWindow._) {
      onceScriptLoad(callback.$, onload);
    } else {
      onload();
    }
  });
  contentDocument = iframe.contentWindow.document;
  contentDocument.open().write("<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title>" + uuid + "</title><link rel=\"stylesheet\" href=\"" + baseURL + "assets/css/buttons.css\"><script>document.location.hash = \"" + hash + "\";</script></head><body><script src=\"" + baseURL + "buttons.js\"></script></body></html>");
  contentDocument.close();
};


/* istanbul ignore next */

renderAll = function() {
  var anchor, anchors, j, k, len, len1, ref;
  anchors = [];
  if (document.querySelectorAll) {
    anchors = document.querySelectorAll("a." + buttonClass);
  } else {
    ref = document.getElementsByTagName("a");
    for (j = 0, len = ref.length; j < len; j++) {
      anchor = ref[j];
      if (~(" " + anchor.className + " ").replace(/[ \t\n\f\r]+/g, " ").indexOf(" " + buttonClass + " ")) {
        anchors.push(anchor);
      }
    }
  }
  for (k = 0, len1 = anchors.length; k < len1; k++) {
    anchor = anchors[k];
    render(anchor);
  }
};

export { render };
