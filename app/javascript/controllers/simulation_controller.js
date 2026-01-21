import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }
  static targets = ["button"]

  connect() {
    this.running = false
  }

  toggle() {
    this.running = !this.running
    this.buttonTarget.innerText = this.running ? "Stop Simulazione" : "Start Simulazione"
    
    if (this.running) {
      this.runLoop()
    }
  }

  runLoop() {
    if (!this.running) return

    // Chiama l'azione server 'advance'
    fetch(this.urlValue, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
    .then(response => response.text())
    .then(html => {
      // Turbo gestisce l'aggiornamento del DOM tramite lo stream
      document.body.insertAdjacentHTML("beforeend", html) // Turbo stream injection
      
      // Ritardo per l'animazione (es. 500ms) e ripetizione
      if (this.running) {
        setTimeout(() => this.runLoop(), 500) 
      }
    })
  }
}