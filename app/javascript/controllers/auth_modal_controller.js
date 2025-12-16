import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tabBtn", "panel"]

  initialize() {
    this._onSubmitClick = this._onSubmitClick.bind(this)
  }

  connect() {
    this.tabButtons = this.tabBtnTargets || []
    this.panels = this.panelTargets || []
    requestAnimationFrame(() => this.attachSubmitHandlers())
  }

  switch(event) {
    const btn = event.currentTarget
    const panelName = btn.dataset.panel

    // active state on buttons
    this.tabButtons.forEach(b => b.classList.remove('active'))
    btn.classList.add('active')

    // toggle panels by data-panel-name (show only active)
    this.panels.forEach(p => {
      const name = p.dataset.panelName
      if (name === panelName) {
        p.classList.add('active')
      } else {
        p.classList.remove('active')
      }
    })
  }

  _onSubmitClick(e) {
    const btn = e.currentTarget
    btn.classList.add('btn-sent')
    try { btn.disabled = true } catch (err) {}
  }

  attachSubmitHandlers() {
    // Attach to form submit and perform fetch to keep user on /auth on errors
    const forms = this.element.querySelectorAll('form')
    const csrf = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content')
    forms.forEach(form => {
      form.removeEventListener('submit', form._authSubmitHandler)
      const handler = async (ev) => {
        ev.preventDefault()
        // client-side password strength check for registration forms
        const pwd = form.querySelector('input[name="user[password]"]') || form.querySelector('input[name*="password"]')
        const pwdConfirm = form.querySelector('input[name="user[password_confirmation]"]')
        if (pwd && pwdConfirm) {
          const val = pwd.value || ''
          const score = this.evaluatePassword(val)
          if (score < 2) {
            const toastContainer = document.querySelector('[data-controller="toast"]')
            if (toastContainer) toastContainer.dispatchEvent(new CustomEvent('toast:show', { detail: { message: 'Password is too weak. Use 8+ chars, add numbers and symbols.', type: 'error' } }))
            this.markFieldError(pwd)
            return
          }
        }
        const action = form.getAttribute('action') || window.location.href
        const method = (form.getAttribute('method') || 'post').toUpperCase()
        const formData = new FormData(form)

        const headers = { 'Accept': 'text/html' }
        if (csrf) headers['X-CSRF-Token'] = csrf

        try {
          const response = await fetch(action, { method, body: formData, credentials: 'same-origin', headers, redirect: 'follow' })
          const text = await response.text()

          // Parse returned HTML and look for initial-toast elements or server-side alerts
          const parser = new DOMParser()
          const doc = parser.parseFromString(text, 'text/html')

          const toastEls = Array.from(doc.querySelectorAll('.initial-toast'))
          const alerts = Array.from(doc.querySelectorAll('.alert'))
          const errorSummary = doc.querySelector('#error_explanation')

          const toasts = []
          toastEls.forEach(t => toasts.push({ msg: t.dataset.toastMessage || t.textContent.trim(), type: t.dataset.toastType || 'error' }))
          alerts.forEach(a => toasts.push({ msg: a.textContent.trim(), type: a.classList.contains('alert-success') ? 'success' : 'error' }))
          if (errorSummary && toasts.length === 0) {
            // collect list items
            const items = Array.from(errorSummary.querySelectorAll('li')).map(li => li.textContent.trim())
            items.forEach(it => toasts.push({ msg: it, type: 'error' }))
          }

          const toastContainer = document.querySelector('[data-controller="toast"]')
          if (toasts.length > 0 && toastContainer) {
            // show toasts
            toasts.forEach(t => toastContainer.dispatchEvent(new CustomEvent('toast:show', { detail: { message: t.msg, type: t.type } })))
            const hasError = toasts.some(t => t.type === 'error')
            const hasSuccess = toasts.some(t => t.type === 'success')
            // highlight fields related to errors
            if (hasError) this.highlightFieldsFromMessages(toasts.map(t => t.msg))
            // if there are errors, do not navigate
            if (hasError) return
            // if success messages only, navigate to response.url or reload
            if (hasSuccess) {
              if (response.redirected || (response.url && response.url !== window.location.href)) {
                window.location = response.url
                return
              }
              window.location.reload()
              return
            }
          }

          // No errors detected — if response redirected or URL changed, navigate there
          if (response.redirected || response.url && response.url !== window.location.href) {
            window.location = response.url
            return
          }

          // Fallback: if response includes the auth page content, replace current auth content
          const newAuth = doc.querySelector('.auth-shell')
          const currentAuth = document.querySelector('.auth-shell')
          if (newAuth && currentAuth) {
            currentAuth.replaceWith(newAuth)
            // re-attach handlers to new content
            requestAnimationFrame(() => this.attachSubmitHandlers())
            return
          }

          // Otherwise, as a fallback, reload the page
          window.location.reload()
        } catch (err) {
          console.error('Auth submit error', err)
          const toastContainer = document.querySelector('[data-controller="toast"]')
          if (toastContainer) toastContainer.dispatchEvent(new CustomEvent('toast:show', { detail: { message: 'Network error', type: 'error' } }))
        }
      }
      form._authSubmitHandler = handler
      form.addEventListener('submit', handler)
      // Live password strength meter for password inputs (exclude confirmation)
      try {
        const pwdInputs = Array.from(form.querySelectorAll('input[type="password"]'))
        const pwd = pwdInputs.find(i => !/confirm|confirmation/i.test(i.name))
        if (pwd) {
          let meter = pwd.nextElementSibling
          if (!meter || !meter.classList.contains('password-meter')) {
            meter = document.createElement('div')
            meter.className = 'password-meter'
            meter.setAttribute('aria-hidden', 'true')
            pwd.insertAdjacentElement('afterend', meter)
          }
          const update = () => {
            const score = this.evaluatePassword(pwd.value || '')
            meter.dataset.score = String(score)
            meter.classList.remove('weak','ok','strong')
            if (score <= 1) meter.classList.add('weak')
            else if (score === 2) meter.classList.add('ok')
            else meter.classList.add('strong')
          }
          pwd.removeEventListener('input', pwd._passwordMeterHandler)
          pwd._passwordMeterHandler = update
          pwd.addEventListener('input', update)
          // initialize
          update()
        }
      } catch (e) {
        // silently ignore meter attachment errors
      }
    })
  }

  evaluatePassword(value) {
    let score = 0
    if (!value) return 0
    if (value.length >= 8) score += 1
    if (/[A-Z]/.test(value) && /[0-9]/.test(value)) score += 1
    if (/[^A-Za-z0-9]/.test(value)) score += 1
    return score // 0..3
  }

  markFieldError(input) {
    if (!input) return
    input.classList.add('field-error','animate-shake')
    setTimeout(() => input.classList.remove('animate-shake'), 600)
  }

  highlightFieldsFromMessages(messages) {
    messages.forEach(msg => {
      const text = msg.toLowerCase()
      if (text.includes('password')) {
        const pwd = this.element.querySelector('input[name="user[password]"]') || this.element.querySelector('input[name*="password"]')
        this.markFieldError(pwd)
      }
      if (text.includes('email')) {
        const em = this.element.querySelector('input[name="user[email]"]') || this.element.querySelector('input[type="email"]')
        this.markFieldError(em)
      }
      if (text.includes('confirmation')) {
        const confirm = this.element.querySelector('input[name="user[password_confirmation]"]')
        this.markFieldError(confirm)
      }
    })
  }
}
