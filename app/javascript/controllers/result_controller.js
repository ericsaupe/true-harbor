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
    // Update family to be contacted
    fetch(`/results/${this.idValue}`, {
      method: "PUT",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
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
}
