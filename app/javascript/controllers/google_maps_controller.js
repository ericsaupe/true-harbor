import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    lat: Number,
    lng: Number,
    points: Array
  }
  static targets = [ "map" ]

  connect() {
    this.initializeMap()
  }

  initializeMap() {
    // The location of the Search
    const search = { lat: this.latValue, lng: this.lngValue }
    // The map, centered at the Search
    const map = new google.maps.Map(this.mapTarget, {
      zoom: 11,
      center: search,
    })
    // A marker, positioned at the Search
    new google.maps.Marker({
      position: search,
      map: map,
      icon: {
        url: "http://maps.google.com/mapfiles/kml/pal4/icon47.png"
      }
    })

    this.pointsValue.forEach(result => {
      const family = result.family
      const point = {
        lat: parseFloat(family.latitude),
        lng: parseFloat(family.longitude)
      }
      const infoWindow = new google.maps.InfoWindow({
        content: this.infoWindowContent(family),
        ariaLabel: family.name,
      })
      const marker = new google.maps.Marker({
        position: point,
        map: map,
        label: result.score.toString()
      })

      marker.addListener("click", () => {
        infoWindow.open({ anchor: marker, map })
      })
    })
  }

  infoWindowContent(family) {
    return `
      <div class="info-window">
        <h3>${family.name}</h3>
        <p>${family.address_1}</p>
        <p>${family.address_2}</p>
        <p>${family.city}, ${family.state} ${family.zip}</p>
        <p>${family.phone}</p>
        <p>${family.email}</p>
      </div>
    `
  }
}
