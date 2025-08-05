import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["popup"]
  static values = {
    showDelay: { type: Number, default: 800 },
    autoCloseDelay: { type: Number, default: 7000 },
    animationDuration: { type: Number, default: 300 }
  }

  //connect() は要素がDOMに追加された瞬間に自動実行される！
  connect() {
    console.log("RecommendationPopup controller connected")
    this.showPopup()
    this.scheduleAutoClose()
  }

  showPopup() {
    this.showTimer = setTimeout(() => {
      this.popupTarget.classList.remove('translate-x-full') //このクラスを取り除いて、表示させる
    }, this.showDelayValue)
  }
//自動クローズタイマー
  scheduleAutoClose() {
    this.autoCloseTimer = setTimeout(() => {
      this.close()
    }, this.autoCloseDelayValue)
  }
  
  close() {
    if (this.autoCloseTimer) clearTimeout(this.autoCloseTimer)
    this.popupTarget.classList.add('translate-x-full') //このクラスを追加して非表示にする
    this.removeTimer = setTimeout(() => {
      this.clearSession()
      this.element.remove()
    }, this.animationDurationValue)
  }


  async clearSession() { //非同期のasyncを記載してpromiseを返す
    try { //catch
      const response = await fetch('/clear_recommendation_session', { //awaitにてpromiseの結果が返るまで待つ
        method: 'POST',
        headers: {
          'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
          'Content-Type': 'application/json'
        }
      })

      if (!response.ok) {
        console.error('Failed to clear session')
      }
    } catch (error) {
      console.error('Error clearing session:', error)
    }
  }

    //disconnect() は要素がDOMから削除された瞬間に自動実行される
  disconnect() {
    if (this.showTimer) clearTimeout(this.showTimer)
    if (this.autoCloseTimer) clearTimeout(this.autoCloseTimer)
    if (this.removeTimer) clearTimeout(this.removeTimer)
  }
}