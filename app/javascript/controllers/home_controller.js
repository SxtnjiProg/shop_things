import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.el = this.element
    this.bg = this.el.querySelector('.hero-bg')
    this.visual = this.el.querySelector('.hero-visual')
    this.bind()
  }

  bind() {
    // subtle parallax on mousemove inside hero
    try {
      this._onMove = (e) => {
        const rect = this.el.getBoundingClientRect()
        const x = (e.clientX - rect.left) / rect.width - 0.5
        const y = (e.clientY - rect.top) / rect.height - 0.5
        if (this.bg) this.bg.style.transform = `translate(${x * 6}px, ${y * 6}px) scale(1.03)`
        if (this.visual) this.visual.style.transform = `translate(${x * -8}px, ${y * -6}px)`
      }
      this._onLeave = () => {
        if (this.bg) this.bg.style.transform = ''
        if (this.visual) this.visual.style.transform = ''
      }
      this.el.addEventListener('mousemove', this._onMove)
      this.el.addEventListener('mouseleave', this._onLeave)
    } catch (err) {
      // ignore
    }
  }

  disconnect() {
    if (this._onMove) this.el.removeEventListener('mousemove', this._onMove)
    if (this._onLeave) this.el.removeEventListener('mouseleave', this._onLeave)
  }
}
