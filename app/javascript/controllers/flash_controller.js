import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.close()
    }, 5000)
  }

  close() {
    this.element.classList.add("animate__fadeOut")
    setTimeout(() => { this.element.remove() }, 1000)
  }
}
