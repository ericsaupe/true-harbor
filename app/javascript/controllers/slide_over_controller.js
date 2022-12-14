import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "backdrop", "container", "panel", "panelContent" ]

  static values = {
    loadingHTML: String,
    searchId: Number
  }

  connect() {
    this.loadingHTMLValue = this.panelContentTarget.innerHTML
  }

  slideIn(event) {
    this.backdropTarget.classList.remove("-translate-x-full")
    this.containerTarget.classList.remove("-translate-x-full", "hidden")
    this.panelTarget.classList.add("animate__animated", "animate__slideInRight", "animate__faster")

    const familyId = event.target.dataset.familyId || event.target.closest("[data-family-id]").dataset.familyId
    this.load(familyId)
    this.element.addEventListener('animationend', () => {
      this.backdropTarget.classList.add("backdrop-blur-sm")
      this.panelTarget.classList.remove("animate__animated", "animate__slideInRight", "animate__faster")
    }, { once: true })
  }

  load(familyId) {
    this.panelContentTarget.innerHTML = this.loadingHTMLValue
    fetch(`/families/${familyId}?layout=false&search_id=${this.searchIdValue}`)
      .then(response => response.text())
      .then(html => this.panelContentTarget.innerHTML = html)
  }

  slideOut() {
    this.panelTarget.classList.add("animate__animated", "animate__slideOutRight")
    this.backdropTarget.classList.remove("backdrop-blur-sm")
    this.element.addEventListener('animationend', () => {
      this.backdropTarget.classList.add("-translate-x-full")
      this.containerTarget.classList.add("-translate-x-full", "hidden")
      this.panelTarget.classList.remove("animate__animated", "animate__slideOutRight")
    }, { once: true })
  }
}
