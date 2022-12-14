import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    timer: Number,
  }

  connect() {
    const url = this.urlValue
    const element = this.element
    const protocol = (location.protocol === "https:") ? "wss:" : "ws:"
    const socket = new WebSocket(`${protocol}//${window.location.host}/cable`)
    socket.onclose = function(_event) {
      const timerId = setInterval(() => {
        fetch(url, {
          headers: {
            Accept: "text/vnd.turbo-stream.html",
          },
        })
          .then(r => r.text())
          .then(html => Turbo.renderStreamMessage(html))
      }, 5000)
      element.setAttribute("data-polling-timer-value", timerId)
    }
  }

  disconnect() {
    clearInterval(this.timerValue)
  }
}
