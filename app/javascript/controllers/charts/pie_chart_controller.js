import { Controller } from "@hotwired/stimulus"
import { Chart, registerables } from "chart.js"

export default class extends Controller {
  static targets = [ "canvas" ]
  static values = { data: Array, title: String }

  initializeChartJs() {
    Chart.register(...registerables)
  }

  connect() {
    this.initializeChartJs()
    const data = this.dataValue
    const title = this.titleValue
    const config = {
      type: "pie",
      data: {
        labels: data.map(row => row.type),
        datasets: [
          {
            data: data.map(row => row.count)
          }
        ]
      },
      options: {
        plugins: {
          title: {
            display: true,
            text: title
          }
        }
      }
    }

    new Chart(this.canvasTarget, config)
  }
}
