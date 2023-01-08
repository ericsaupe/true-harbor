import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  static values = { with: String }

  connect() {
    this.element.dataset["action"] = "submit->form#disableForm"
    flatpickr(".flatpickr", {
      minDate: Date.now(),
      dateFormat: "Y-m-d",
      altInput: true,
      altFormat: "F j, Y",
      onReady: (_selectedDates, _dateStr, instance) => {
        instance.altInput.classList.remove("text-white")
      }
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
