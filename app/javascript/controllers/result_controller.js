import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    id: Number,
    state: String
  }

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

  toggleSelected(event) {
    event.preventDefault()
    this.updateState("selected")
  }

  toggleDeclined(event) {
    event.preventDefault()
    this.updateState("declined")
  }

  toggleWaiting(event) {
    event.preventDefault()
    this.updateState("waiting")
  }
}
