import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    id: Number,
    selected: Boolean
  }
  toggleSelected(event) {
    event.preventDefault()
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
          selected: !this.selectedValue
        }
      })
    }).then(_response => { this.selectedValue = !this.selectedValue })
  }
}
