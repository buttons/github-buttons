'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var document = window.document;

var encodeURIComponent = window.encodeURIComponent;

var decodeURIComponent = window.decodeURIComponent;

var Math = window.Math;

var createElement = function(tag) {
  return document.createElement(tag);
};

var baseURL, buttonClass, uuid;

buttonClass = "github-button";

uuid = "faa75404-3b97-5585-b449-4bc51338fbd1";


/* istanbul ignore next */

baseURL = (/^http:/.test(document.location) ? "http" : "https") + "://buttons.github.io/";

var parseOptions = function(anchor) {
  var attribute, deprecate, i, len, options, ref;
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
    exports.render(anchor);
  }
};

/* istanbul ignore next */

exports.render = function(targetNode, options) {
  var contentDocument, hash, iframe, name, onload, ref, title, value;
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
};
