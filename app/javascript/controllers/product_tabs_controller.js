import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  connect() {
    this.buttons = Array.from(this.element.querySelectorAll('.tab-btn'))
    // Прив’язуємо selectTab до кнопок
    this.selectTab = this.selectTab.bind(this)
    this.buttons.forEach(btn => btn.addEventListener('click', this.selectTab))
  }

  disconnect() {
    this.buttons.forEach(btn => btn.removeEventListener('click', this.selectTab))
  }

  // Метод для перемикання вкладок
  selectTab(event) {
    const btn = event.currentTarget
    const tabName = btn.dataset.tab

    // Видаляємо активний стан у всіх кнопок і панелей
    this.buttons.forEach(b => b.classList.remove('active'))
    this.panelTargets.forEach(p => p.classList.remove('active'))

    // Додаємо активний стан для кнопки
    btn.classList.add('active')

    // Знаходимо панель із data-tab-name
    const panel = this.panelTargets.find(p => p.dataset.tabName === tabName)
    if (panel) {
      panel.classList.add('active')
      panel.classList.remove('fade-in')
      void panel.offsetWidth
      panel.classList.add('fade-in')
    }
  }

  // Показ/приховання форми додавання відгуку
  toggleReviewForm(event) {
    event.preventDefault()
    const form = this.element.querySelector('.review-form')
    if (!form) return
    form.classList.toggle('visible')
    if (form.classList.contains('visible')) {
      const input = form.querySelector('textarea, input')
      if (input) input.focus()
    }
  }
}
