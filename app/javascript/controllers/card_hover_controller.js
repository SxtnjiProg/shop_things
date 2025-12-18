import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "mainImage" ]
  static values = { secondaryImageUrl: String }

  connect() {
    this.originalImageUrl = this.mainImageTarget.style.backgroundImage;
  }

  // При наведенні мишки (mouseover)
  hoverIn() {
    // Перевіряємо, чи є друга картинка
    if (this.secondaryImageUrlValue) {
      this.mainImageTarget.style.backgroundImage = `url('${this.secondaryImageUrlValue}')`;
    }
  }

  // При відведенні мишки (mouseout)
  hoverOut() {
    // Повертаємо оригінальну картинку
    this.mainImageTarget.style.backgroundImage = this.originalImageUrl;
  }
}