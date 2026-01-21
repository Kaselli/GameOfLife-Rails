import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }
  static targets = ["button"]

  connect() {
    this.running = false
    console.log("Stimulus connesso alla simulazione!")
  }

  toggle() {
    this.running = !this.running
    this.buttonTarget.innerText = this.running ? "Stop Simulazione" : "Start Simulazione"
    
    if (this.running) {
      console.log("Simulazione partita...");
      this.runLoop()
    }
  }

  runLoop() {
    if (!this.running) return

    fetch(this.urlValue, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Accept": "text/vnd.turbo-stream.html"
      }
    })
    .then(response => {
      if (response.ok) return response.text()
      throw new Error("Errore nella chiamata al server")
    })
    .then(html => {
      // Questo applica l'aggiornamento Turbo Stream manualmente
      Turbo.renderStreamMessage(html)
      
      if (this.running) {
        setTimeout(() => this.runLoop(), 500) 
      }
    })
    .catch(error => {
      console.error(error)
      this.running = false
      this.buttonTarget.innerText = "Errore - Start"
    })
  }
}