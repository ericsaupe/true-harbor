import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "backdrop", "container", "menu" ]

  openMenu() {
    this.backdropTarget.classList.add("transition-opacity", "ease-linear", "duration-300", "bg-opacity-0", "-translate-x-full")
    this.containerTarget.classList.add("transition", "ease-in-out", "duration-300", "transform", "-translate-x-full")
    setTimeout(() => {
      this.backdropTarget.classList.remove("transition-opacity", "ease-linear", "duration-300", "bg-opacity-0", "-translate-x-full")
      this.backdropTarget.classList.add("bg-opacity-100", "translate-x-0")
      this.containerTarget.classList.remove("transition", "ease-in-out", "duration-300", "transform", "-translate-x-full")
      this.containerTarget.classList.add("translate-x-0")
    }, 300)
  }

  closeMenu() {
    this.backdropTarget.classList.add("transition-opacity", "ease-linear", "duration-300", "bg-opacity-100", "translate-x-0")
    this.containerTarget.classList.add("transition", "ease-in-out", "duration-300", "transform", "translate-x-0")
    setTimeout(() => {
      this.backdropTarget.classList.remove("transition-opacity", "ease-linear", "duration-300", "bg-opacity-100", "translate-x-0")
      this.backdropTarget.classList.add("bg-opacity-0", "-translate-x-full")
      this.containerTarget.classList.remove("transition", "ease-in-out", "duration-300", "transform", "translate-x-0")
      this.containerTarget.classList.add("-translate-x-full")
    }, 300)
  }
}
