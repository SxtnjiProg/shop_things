import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["number", "name", "expiry", "cvc", "submitBtn"]

  connect() {
    this.validateForm()
  }

  // Форматування номеру картки (0000 0000 0000 0000)
  formatNumber(e) {
    let value = e.target.value.replace(/\D/g, "")
    value = value.substring(0, 16)
    let formattedValue = value.match(/.{1,4}/g)?.join(" ") || value
    e.target.value = formattedValue
    this.validateForm()
  }

  // Форматування дати (MM/YY)
  formatExpiry(e) {
    let value = e.target.value.replace(/\D/g, "")
    if (value.length >= 2) {
      value = value.substring(0, 2) + "/" + value.substring(2, 4)
    }
    e.target.value = value
    this.validateForm()
  }

  // Обмеження CVV (3 цифри)
  formatCvc(e) {
    let value = e.target.value.replace(/\D/g, "")
    e.target.value = value.substring(0, 3)
    this.validateForm()
  }

  // Перевірка всіх полів для активації кнопки
  validateForm() {
    const numberValid = this.numberTarget.value.replace(/\s/g, "").length === 16
    const expiryValid = this.expiryTarget.value.length === 5
    const cvcValid = this.cvcTarget.value.length === 3
    const nameValid = this.nameTarget.value.length > 2

    if (numberValid && expiryValid && cvcValid && nameValid) {
      this.submitBtnTarget.disabled = false
      this.submitBtnTarget.classList.remove("btn-secondary")
      this.submitBtnTarget.classList.add("btn-success")
    } else {
      this.submitBtnTarget.disabled = true
      this.submitBtnTarget.classList.remove("btn-success")
      this.submitBtnTarget.classList.add("btn-secondary")
    }
  }
}