import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview"]

  previewImage() {
    console.log("previewImage triggered")
    const file = this.inputTarget.files[0]
    if (!file) return
    
    const reader = new FileReader()
    reader.onload = e => {
      console.log("image loaded")
      this.previewTarget.src = e.target.result
    }
    reader.readAsDataURL(file)
  }
}