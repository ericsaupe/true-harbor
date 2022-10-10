import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "backdrop", "container", "menu" ]

  openMenu() {
    this.backdropTarget.classList.remove("-translate-x-full")
    this.containerTarget.classList.remove("-translate-x-full", "hidden")
    this.containerTarget.classList.add("animate__animated", "animate__slideInLeft", "animate__faster")
    this.backdropTarget.classList.add("backdrop-blur-sm", "bg-opacity-60", "translate-x-0")
    this.element.addEventListener('animationend', () => {
      this.containerTarget.classList.remove("animate__animated", "animate__slideInLeft", "animate__faster")
    }, { once: true })
  }

  closeMenu() {
    this.containerTarget.classList.add("animate__animated", "animate__slideOutLeft", "animate__faster")
    this.element.addEventListener('animationend', () => {
      this.containerTarget.classList.remove("animate__animated", "animate__slideOutLeft", "animate__faster")
      this.backdropTarget.classList.remove("backdrop-blur-sm", "bg-opacity-60", "translate-x-0")
      this.backdropTarget.classList.add("-translate-x-full")
      this.containerTarget.classList.add("-translate-x-full", "hidden")
    }, { once: true })
  }
}
