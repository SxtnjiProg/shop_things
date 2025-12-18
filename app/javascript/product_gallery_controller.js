import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mainImage", "thumbnail"]

  // Встановлює головне зображення на основі URL мініатюри, на яку було натиснуто
  selectThumbnail(event) {
    event.preventDefault();
    const newImageUrl = event.currentTarget.dataset.imageUrl;

    // Зміна фонового зображення головного блоку
    this.mainImageTarget.style.backgroundImage = `url('${newImageUrl}')`;

    // Оновлення активного стану мініатюр
    this.thumbnailTargets.forEach(thumb => {
      thumb.classList.remove('active');
      if (thumb === event.currentTarget) {
        thumb.classList.add('active');
      }
    });
  }
}