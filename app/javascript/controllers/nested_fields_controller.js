import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "container", "child" ]

  add(event) {
    const fieldsHTML = event.target.dataset.fields
    this.containerTarget.insertAdjacentHTML("beforeend", fieldsHTML)
    const id = event.target.dataset.id
    const newId = Date.now()
    event.target.dataset.fields = event.target.dataset.fields.replaceAll(id, newId)
  }

  remove(event) {
    const child = event.target.closest("[data-nested-fields-target='child']")
    child.classList.remove("sm:grid")
    child.classList.add("hidden")
    child.querySelector("[data-nested-fields-target='destroy']").value = true
  }
}
