import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    id: Number,
    allowEvent: Boolean
  }
  familyContacted(event) {
    if (this.allowEventValue) {
      return true
    }
    event.preventDefault()
    // Update family to be contacted
    fetch(`/families/${this.idValue}/contacted`, {
      method: "PUT",
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({
        family: {
          last_contacted_at: new Date().toISOString()
        }
      })
    }).then(_response => {
      if (this.allowEventValue) {
        this.allowEventValue = false
      } else {
        this.allowEventValue = true
        event.target.click()
      }
    })
  }
}
