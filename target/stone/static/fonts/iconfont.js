;(function(window) {

  var svgSprite = '<svg>' +
    '' +
    '<symbol id="icon-showup" viewBox="0 0 1024 1024">' +
    '' +
    '<path d="M230.136897 692.928722 157.716524 600.410586 511.926319 323.222519 866.182164 600.364537 793.761792 692.883697 511.926319 472.371444Z"  ></path>' +
    '' +
    '</symbol>' +
    '' +
    '<symbol id="icon-icon-search" viewBox="0 0 1024 1024">' +
    '' +
    '<path d="M408.738653 178.369343c145.073487 0 262.677994 117.67407 262.677994 262.837578 0 44.397203-11.09214 86.144895-30.518474 122.82169l182.620835 182.727225-0.145263 0.146286c14.242909 14.025015 23.157131 33.48613 23.157131 55.087313 0 42.688831-34.570486 77.266478-77.265455 77.266478-21.560264 0-41.025471-8.884555-55.013658-23.1602l0-0.035804L531.702537 673.401223c-36.67168 19.498965-78.492004 30.660667-122.963884 30.660667C263.70404 704.06189 146.099532 586.350993 146.099532 441.206921 146.099532 296.043413 263.70404 178.369343 408.738653 178.369343zM741.578549 828.731077c7.030921 7.286665 16.776823 11.886993 27.68585 11.886993 21.346462 0 38.637842-17.289335 38.637842-38.630681 0-10.946877-4.607489-20.659021-11.892108-27.763596l0.217894-0.145263L619.667309 597.405283c-15.443884 20.840088-33.854402 39.213778-54.582985 54.687329L741.578549 828.731077zM408.738653 660.213003c120.900539 0 218.899692-98.068715 218.899692-219.007105 0-120.970102-98.000176-219.037794-218.899692-219.037794-120.860643 0-218.855704 98.067692-218.855704 219.037794C189.882949 562.144288 287.879033 660.213003 408.738653 660.213003z"  ></path>' +
    '' +
    '<path d="M408.738653 287.889263c84.663624 0 153.227636 68.623345 153.227636 153.317658 0 6.052955-4.855049 10.944831-10.944831 10.944831-6.016128 0-10.942785-4.890853-10.942785-10.944831 0-72.589427-58.781283-131.407536-131.34002-131.407536-6.015105 0-10.943808-4.913359-10.943808-10.962222C397.794845 292.783185 402.723548 287.889263 408.738653 287.889263z"  ></path>' +
    '' +
    '</symbol>' +
    '' +
    '<symbol id="icon-iconul" viewBox="0 0 1024 1024">' +
    '' +
    '<path d="M352 512l512 0C881.664 512 896 497.664 896 480 896 462.336 881.664 448 864 448l-512 0C334.336 448 320 462.336 320 480 320 497.664 334.336 512 352 512zM352 256l512 0C881.664 256 896 241.664 896 224 896 206.336 881.664 192 864 192l-512 0C334.336 192 320 206.336 320 224 320 241.664 334.336 256 352 256zM352 768l512 0c17.664 0 32-14.336 32-32 0-17.664-14.336-32-32-32l-512 0C334.336 704 320 718.336 320 736 320 753.664 334.336 768 352 768zM128 224A1 1 1080 1 0 192 224 1 1 1080 1 0 128 224zM128 480A1 1 1080 1 0 192 480 1 1 1080 1 0 128 480zM128 736A1 1 1080 1 0 192 736 1 1 1080 1 0 128 736z"  ></path>' +
    '' +
    '</symbol>' +
    '' +
    '<symbol id="icon-article" viewBox="0 0 1024 1024">' +
    '' +
    '<path d="M883.541333 1024 140.458667 1024c-7.509333 0-13.596444-6.087111-13.596444-13.596444L126.862222 238.686815c0-3.612444 1.441185-7.082667 4.001185-9.633185L357.05363 3.953778C359.604148 1.422222 363.055407 0 366.648889 0l516.892444 0c7.509333 0 13.596444 6.087111 13.596444 13.596444l0 996.816593C897.137778 1017.912889 891.050667 1024 883.541333 1024zM154.055111 996.816593l715.899259 0L869.95437 27.183407 372.252444 27.183407 154.055111 244.347259 154.055111 996.816593z"  ></path>' +
    '' +
    '<path d="M379.249778 266.334815 158.587259 266.334815c-7.509333 0-13.596444-6.087111-13.596444-13.596444s6.087111-13.596444 13.596444-13.596444l207.066074 0L365.653333 31.715556c0-7.509333 6.087111-13.596444 13.596444-13.596444 7.509333 0 13.596444 6.087111 13.596444 13.596444l0 221.022815C392.836741 260.247704 386.74963 266.334815 379.249778 266.334815z"  ></path>' +
    '' +
    '<path d="M746.799407 249.201778 527.853037 249.201778c-7.509333 0-13.596444-6.087111-13.596444-13.596444s6.087111-13.596444 13.596444-13.596444l218.936889 0c7.509333 0 13.596444 6.087111 13.596444 13.596444S754.308741 249.201778 746.799407 249.201778z"  ></path>' +
    '' +
    '<path d="M746.799407 412.321185 309.010963 412.321185c-7.509333 0-13.596444-6.087111-13.596444-13.596444s6.087111-13.596444 13.596444-13.596444l437.778963 0c7.509333 0 13.596444 6.087111 13.596444 13.596444S754.308741 412.321185 746.799407 412.321185z"  ></path>' +
    '' +
    '<path d="M746.799407 561.844148 295.329185 561.844148c-7.509333 0-13.596444-6.087111-13.596444-13.596444 0-7.509333 6.087111-13.596444 13.596444-13.596444l451.470222 0c7.509333 0 13.596444 6.087111 13.596444 13.596444C760.38637 555.757037 754.308741 561.844148 746.799407 561.844148z"  ></path>' +
    '' +
    '<path d="M746.799407 724.954074 295.329185 724.954074c-7.509333 0-13.596444-6.087111-13.596444-13.596444s6.087111-13.596444 13.596444-13.596444l451.470222 0c7.509333 0 13.596444 6.087111 13.596444 13.596444S754.308741 724.954074 746.799407 724.954074z"  ></path>' +
    '' +
    '<path d="M746.799407 888.073481 295.329185 888.073481c-7.509333 0-13.596444-6.087111-13.596444-13.596444s6.087111-13.596444 13.596444-13.596444l451.470222 0c7.509333 0 13.596444 6.087111 13.596444 13.596444S754.308741 888.073481 746.799407 888.073481z"  ></path>' +
    '' +
    '</symbol>' +
    '' +
    '<symbol id="icon-topic" viewBox="0 0 1024 1024">' +
    '' +
    '<path d="M511.299547 79.45461c-246.6434 0-447.304536 176.609347-447.304536 393.684314 0 97.759511 40.374546 190.55701 114.004497 262.765589 0.532119 32.514531 1.323135 96.236831 1.839905 141.945873l0.38067 34.644031c0.132006 11.307533 6.26775 21.661346 16.070001 27.128871 4.670369 2.596128 9.827833 3.874237 14.980179 3.874237 5.658883 0 11.31879-1.561565 16.312524-4.665253l29.197996-18.205641c59.780525-37.249369 94.922906-59.175751 115.976408-73.02927 44.528146 12.746302 91.062995 19.207457 138.542356 19.207457 246.647493 0 447.308629-176.59809 447.308629-393.665895C958.608176 256.063957 757.948063 79.45461 511.299547 79.45461zM511.299547 804.089451c-46.266743 0-91.428316-6.947226-134.227074-20.658506-9.117658-2.920516-19.091824-1.428535-27.01733 4.076852-15.876596 11.044544-47.224558 30.729885-108.364033 68.833715-0.593518-50.973952-1.404999-113.294322-1.846044-134.86664-0.171915-8.599865-3.843538-16.753569-10.140964-22.545482-66.813708-61.428048-103.613846-141.610228-103.613846-225.788419 0-182.502567 172.805718-330.967924 385.210315-330.967924 212.404598 0 385.211339 148.465356 385.211339 330.967924C896.511909 655.633305 723.705168 804.089451 511.299547 804.089451zM357.758592 433.860339c-23.326265 0-42.225707 19.085684-42.225707 42.646286 0 23.518646 18.898419 42.630936 42.225707 42.630936 23.285333 0 42.205241-19.11229 42.205241-42.630936C399.963833 452.947046 381.043924 433.860339 357.758592 433.860339zM509.216095 433.860339c-23.322172 0-42.225707 19.085684-42.225707 42.646286 0 23.518646 18.903535 42.630936 42.225707 42.630936 23.269983 0 42.189891-19.11229 42.189891-42.630936C551.40701 452.947046 532.486078 433.860339 509.216095 433.860339zM660.659273 433.860339c-23.328311 0-42.22673 19.085684-42.22673 42.646286 0 23.518646 18.898419 42.630936 42.22673 42.630936 23.284309 0 42.203194-19.11229 42.203194-42.630936C702.862467 452.947046 683.943582 433.860339 660.659273 433.860339z"  ></path>' +
    '' +
    '</symbol>' +
    '' +
    '</svg>'
  var script = function() {
    var scripts = document.getElementsByTagName('script')
    return scripts[scripts.length - 1]
  }()
  var shouldInjectCss = script.getAttribute("data-injectcss")

  /**
   * document ready
   */
  var ready = function(fn) {
    if (document.addEventListener) {
      if (~["complete", "loaded", "interactive"].indexOf(document.readyState)) {
        setTimeout(fn, 0)
      } else {
        var loadFn = function() {
          document.removeEventListener("DOMContentLoaded", loadFn, false)
          fn()
        }
        document.addEventListener("DOMContentLoaded", loadFn, false)
      }
    } else if (document.attachEvent) {
      IEContentLoaded(window, fn)
    }

    function IEContentLoaded(w, fn) {
      var d = w.document,
        done = false,
        // only fire once
        init = function() {
          if (!done) {
            done = true
            fn()
          }
        }
        // polling for no errors
      var polling = function() {
        try {
          // throws errors until after ondocumentready
          d.documentElement.doScroll('left')
        } catch (e) {
          setTimeout(polling, 50)
          return
        }
        // no errors, fire

        init()
      };

      polling()
        // trying to always fire before onload
      d.onreadystatechange = function() {
        if (d.readyState == 'complete') {
          d.onreadystatechange = null
          init()
        }
      }
    }
  }

  /**
   * Insert el before target
   *
   * @param {Element} el
   * @param {Element} target
   */

  var before = function(el, target) {
    target.parentNode.insertBefore(el, target)
  }

  /**
   * Prepend el to target
   *
   * @param {Element} el
   * @param {Element} target
   */

  var prepend = function(el, target) {
    if (target.firstChild) {
      before(el, target.firstChild)
    } else {
      target.appendChild(el)
    }
  }

  function appendSvg() {
    var div, svg

    div = document.createElement('div')
    div.innerHTML = svgSprite
    svgSprite = null
    svg = div.getElementsByTagName('svg')[0]
    if (svg) {
      svg.setAttribute('aria-hidden', 'true')
      svg.style.position = 'absolute'
      svg.style.width = 0
      svg.style.height = 0
      svg.style.overflow = 'hidden'
      prepend(svg, document.body)
    }
  }

  if (shouldInjectCss && !window.__iconfont__svg__cssinject__) {
    window.__iconfont__svg__cssinject__ = true
    try {
      document.write("<style>.svgfont {display: inline-block;width: 1em;height: 1em;fill: currentColor;vertical-align: -0.1em;font-size:16px;}</style>");
    } catch (e) {
      console && console.log(e)
    }
  }

  ready(appendSvg)


})(window)