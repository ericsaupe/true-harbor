import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  changeTimeframe(event) {
    const timeframe = event.target.value
    const turboFrames = document.querySelectorAll("turbo-frame")
    turboFrames.forEach((turboFrame) => {
      let src = turboFrame.getAttribute("src")
      src = this.removeURLParameter(src, "timeframe")
      turboFrame.setAttribute("src", `${src}?timeframe=${timeframe}`)
    })
  }

  removeURLParameter(url, parameter) {
    //prefer to use l.search if you have a location/link object
    var urlparts = url.split('?');
    if (urlparts.length >= 2) {
      var prefix = encodeURIComponent(parameter) + '=';
      var pars = urlparts[1].split(/[&;]/g);

      //reverse iteration as may be destructive
      for (var i = pars.length; i-- > 0;) {
        //idiom for string.startsWith
        if (pars[i].lastIndexOf(prefix, 0) !== -1) {
            pars.splice(i, 1);
        }
      }

      return urlparts[0] + (pars.length > 0 ? '?' + pars.join('&') : '');
    }
    return url;
  }
}
