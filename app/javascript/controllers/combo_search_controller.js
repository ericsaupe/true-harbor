import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "input", "options", "result", "toggle" ]
  static values = { id: Number, open: Boolean }

  toggleOptions() {
    this.openValue = !this.openValue
    if (this.openValue) {
      this.openOptions()
    } else {
      this.closeOptions()
    }
  }

  openOptions() {
    this.optionsTarget.classList.remove("hidden")
  }

  closeOptions() {
    this.optionsTarget.classList.add("hidden")
  }

  windowCloseOptions() {
    if (document.activeElement !== this.inputTarget && document.activeElement !== this.toggleTarget) {
      this.closeOptions()
    }
  }

  search(event) {
    const query = event.target.value
    if (query.length < 3) {
      this.closeOptions()
      return
    }

    fetch(`/searches/${this.idValue}/search_families?q[name_i_cont]=${query}`).then(response => {
      response.text().then(html => {
        this.optionsTarget.innerHTML = html
      })
    })
    this.openOptions()
  }

  select(event) {
    let target = event.target
    if (target.nodeName !== "LI") {
      target = target.closest("li")
    }
    const familyId = target.dataset.familyId
    const selected = target.dataset.selected
    // Grab the CSRF token from the meta tag if it exists. It doesn't exist in test.
    const csrfToken = document.querySelector("meta[name='csrf-token']") && document.querySelector("meta[name='csrf-token']").content
    if (selected !== "true") {
      const queryString = window.location.search
      const urlParams = new URLSearchParams(queryString)
      fetch(`/searches/${this.idValue}/results`, {
        method: "POST",
        headers: {
          "Accept": "text/vnd.turbo-stream.html",
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken
        },
        body: JSON.stringify({
          family_id: familyId,
          selected: selected === "true",
          include_exclusions: urlParams.get("include_exclusions"),
          page: urlParams.get("page")
        })
      }).then(r => r.text())
      .then(html => Turbo.renderStreamMessage(html))
    } else {
      fetch(`/searches/${this.idValue}/results/destroy_by_family/${familyId}`, {
        method: "DELETE",
        headers: {
          "Accept": "text/vnd.turbo-stream.html",
          "Content-Type": "application/json",
          "X-CSRF-Token": csrfToken
        }
      }).then(r => r.text())
        .then(html => Turbo.renderStreamMessage(html))
    }
  }
}
