import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "button", "chevronDown", "chevronUp", "menu" ]
  static values = { open: Boolean }

  toggleMenu() {
    this.openValue = !this.openValue
    if (this.openValue) {
      this.openMenu()
    } else {
      this.closeMenu()
    }
  }

  openMenu() {
    this.chevronUpTarget.classList.remove("hidden")
    this.chevronDownTarget.classList.add("hidden")
    this.menuTarget.classList.add("animate__animated", "animate__fadeIn", "animate__faster", "absolute")
    this.menuTarget.classList.remove("hidden")
    this.element.addEventListener('animationend', () => {
      this.menuTarget.classList.remove("animate__animated", "animate__fadeIn", "animate__faster")
    }, { once: true })
  }

  closeMenu() {
    this.chevronUpTarget.classList.add("hidden")
    this.chevronDownTarget.classList.remove("hidden")
    this.menuTarget.classList.add("animate__animated", "animate__fadeOut", "animate__faster")
    this.element.addEventListener('animationend', () => {
      this.menuTarget.classList.add("hidden")
      this.menuTarget.classList.remove("animate__animated", "animate__fadeOut", "animate__faster", "absolute")
    }, { once: true })
  }

  windowCloseMenu() {
    if (this.openValue && document.activeElement !== this.menuTarget && document.activeElement !== this.buttonTarget ) {
      this.openValue = false
      this.closeMenu()
    }
  }
}
