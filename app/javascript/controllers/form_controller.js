import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { with: String }

  connect() {
    this.element.dataset["action"] = "submit->form#disableForm"
  }

  disableForm() {
    this.submitButtons().forEach(button => {
      button.disabled = true
      if (this.hasWithValue) {
        button.value = this.withValue
      }
    })
  }

  submitButtons() {
    return this.element.querySelectorAll("input[type=\"submit\"]")
  }
}
