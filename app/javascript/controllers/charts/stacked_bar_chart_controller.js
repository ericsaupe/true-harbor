import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"

export default class extends Controller {
  static targets = [ "canvas" ]
  static values = { data: Object, title: String }

  initializeChartJs() {
    Chart.register(...registerables)
  }

  connect() {
    this.initializeChartJs()
    const data = {
      labels: this.dataValue.labels,
      datasets: this.dataValue.datasets
    }
    const title = this.titleValue

    const config = {
      type: "bar",
      data: data,
      options: {
        plugins: {
          title: {
            display: true,
            text: title
          },
          legend: {
            display: false
          }
        },
        responsive: true,
        maintainAspectRatio: false
      }
    }

    new Chart(this.canvasTarget, config)
  }
}
