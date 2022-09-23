import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    setTimeout(() => {
      this.close()
    }, 5000)
  }

  close() {
    this.element.classList.add("animate__animated", "animate__faster", "animate__fadeOut")
    this.element.addEventListener('animationend', () => {
      this.element.remove()
    })
  }
}
