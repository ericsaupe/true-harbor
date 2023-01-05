import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  static values = { with: String }

  connect() {
    this.element.dataset["action"] = "submit->form#disableForm"
    flatpickr(".flatpickr", {
      enableTime: true,
      minDate: "today",
      dateFormat: "Y-m-d H:i",
      altInput: true,
      altFormat: "F j, Y h:i K"
    })
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
