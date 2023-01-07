import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    id: Number,
    state: String
  }

  static targets = [ "button", "contactButton", "contactTime", "row" ]

  updateState(state) {
    if (this.stateValue === state) {
      state = "default"
    }
    // Grab the CSRF token from the meta tag if it exists. It doesn't exist in test.
    const csrfToken = document.querySelector("meta[name='csrf-token']") && document.querySelector("meta[name='csrf-token']").content
    // Update family to be contacted
    fetch(`/results/${this.idValue}`, {
      method: "PUT",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
      body: JSON.stringify({
        result: {
          state: state
        }
      })
    }).then(_response => { this.stateValue = state })
  }

  toggleClassesOnButton(target, classes, newState) {
    const notSelectedClasses = ["bg-white", "hover:bg-pink-50", "text-gray-700"]
    const selectedClasses = ["bg-emerald-500", "hover:bg-emerald-700", "text-white"]
    const declinedClasses = ["bg-red-500", "hover:bg-red-700", "text-white"]
    const waitingClasses  = ["bg-yellow-500", "hover:bg-yellow-700", "text-white"]

    // Ensure we are working with a button
    if (target.tagName !== "button") {
      target = target.closest("button")
    }

    // Update the clicked button
    if(this.stateValue === newState) {
      target.classList.remove(...classes)
      target.classList.add(...notSelectedClasses)
    } else {
      target.classList.add(...classes)
      target.classList.remove(...notSelectedClasses)
    }

    // Update all other buttons
    this.buttonTargets.forEach(button => {
      if (button.dataset.value !== newState) {
        button.classList.remove(...selectedClasses, ...declinedClasses, ...waitingClasses)
        button.classList.add(...notSelectedClasses)
      }
    })
  }

  toggleClassesOnRow(classes, newState) {
    const allClasses = ["bg-emerald-50", "bg-red-50", "bg-yellow-50", "bg-white"]
    this.rowTarget.classList.remove(...allClasses)
    if(this.stateValue === newState) {
      this.rowTarget.classList.add("bg-white")
    } else {
      this.rowTarget.classList.add(...classes)
    }
  }

  toggleSelected(event) {
    event.preventDefault()
    const newState = "selected"
    const selectedButtonClasses = ["bg-emerald-500", "hover:bg-emerald-700", "text-white"]
    const selectedRowClasses = ["bg-emerald-50"]
    this.toggleClassesOnButton(event.target, selectedButtonClasses, newState)
    this.toggleClassesOnRow(selectedRowClasses, newState)
    this.updateState(newState)
  }

  toggleDeclined(event) {
    event.preventDefault()
    const newState = "declined"
    const declinedButtonClasses = ["bg-red-500", "hover:bg-red-700", "text-white"]
    const declinedRowClasses = ["bg-red-50"]
    this.toggleClassesOnButton(event.target, declinedButtonClasses, newState)
    this.toggleClassesOnRow(declinedRowClasses, newState)
    this.updateState(newState)
  }

  toggleWaiting(event) {
    event.preventDefault()
    const newState = "waiting"
    const waitingButtonClasses = ["bg-yellow-500", "hover:bg-yellow-700", "text-white"]
    const waitingRowClasses = ["bg-yellow-50"]
    this.toggleClassesOnButton(event.target, waitingButtonClasses, newState)
    this.toggleClassesOnRow(waitingRowClasses, newState)
    this.updateState(newState)
  }

  updateContacted() {
    this.contactButtonTarget.disabled = true
    this.contactButtonTarget.classList.add("animate__animated", "animate__pulse", "animate__infinite")
    // Grab the CSRF token from the meta tag if it exists. It doesn't exist in test.
    const csrfToken = document.querySelector("meta[name='csrf-token']") && document.querySelector("meta[name='csrf-token']").content
    // Update family to be contacted
    fetch(`/results/${this.idValue}/contacted`, {
      method: "PUT",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-CSRF-Token": csrfToken
      },
    }).then(_response => {
      this.contactButtonTarget.disabled = false
      this.contactButtonTarget.classList.remove("animate__animated", "animate__pulse", "animate__infinite")
      this.contactTimeTarget.innerHTML = "Just now"
    })
  }
}
