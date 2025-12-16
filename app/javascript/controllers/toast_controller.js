import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.container = this.element
    // find any server-rendered initial toasts
    const initial = Array.from(document.querySelectorAll('.initial-toast'))
    initial.forEach(el => {
      const type = el.dataset.toastType || 'info'
      const message = el.dataset.toastMessage || el.textContent.trim()
      this.show(message, type)
      el.remove()
    })

    // Listen for programmatic toast events: dispatch on the container element
    this._ev = (e) => {
      const detail = e.detail || {}
      this.show(detail.message || '', detail.type || 'info', detail.opts || {})
    }
    this.element.addEventListener('toast:show', this._ev)
  }

  show(message, type = 'info', opts = {}) {
    // de-duplicate identical toasts currently visible
    const existing = Array.from(this.container.querySelectorAll('.app-toast .app-toast-body')).map(el => el.textContent.trim())
    if (existing.includes(message)) return null

    const toast = document.createElement('div')
    toast.className = `app-toast app-toast-${type}`
    toast.innerHTML = `
      <div class="app-toast-body">${message}</div>
      <button type="button" class="app-toast-close" aria-label="Dismiss">&times;</button>
    `
    this.container.appendChild(toast)

    // close button
    const close = toast.querySelector('.app-toast-close')
    close.addEventListener('click', () => this.hide(toast))

    // auto-dismiss after 5s
    const t = setTimeout(() => this.hide(toast), opts.duration || 5000)

    // allow manual removal on click of body as well
    toast.addEventListener('click', (ev) => {
      if (ev.target === close) return
      // do nothing on body click
    })

    // store timeout on element for possible cancellation
    toast._timeout = t
    return toast
  }

  hide(toast) {
    if (!toast) return
    try { clearTimeout(toast._timeout) } catch (e) {}
    toast.style.opacity = '0'
    setTimeout(() => toast.remove(), 220)
  }

  disconnect() {
    if (this._ev) this.element.removeEventListener('toast:show', this._ev)
  }
}
