import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.buttons = Array.from(this.element.querySelectorAll('.tab-btn'))
    this.panels = Array.from(this.element.querySelectorAll('.tab-panel'))
    this.onclick = this.onClick.bind(this)
    this.buttons.forEach(btn => btn.addEventListener('click', this.onclick))
  }

  disconnect() {
    this.buttons.forEach(btn => btn.removeEventListener('click', this.onclick))
  }

  onClick(event) {
    const btn = event.currentTarget
    this.buttons.forEach(b => b.classList.remove('active'))
    this.panels.forEach(p => p.classList.remove('active'))

    btn.classList.add('active')
    const target = btn.dataset.target
    const panel = this.element.querySelector(`#${target}`)
    if (panel) {
      // show panel with a small fade-in
      panel.classList.add('active')
      panel.classList.remove('fade-in')
      // trigger reflow then add fade class for animation
      void panel.offsetWidth
      panel.classList.add('fade-in')
    }
  }

  // toggle the review form visibility inside the reviews panel
  toggleReviewForm(event) {
    event.preventDefault()
    const form = this.element.querySelector('.review-form')
    if (!form) return
    form.classList.toggle('visible')
    // focus first input when shown
    if (form.classList.contains('visible')) {
      const input = form.querySelector('textarea, input')
      if (input) input.focus()
    }
  }
}
