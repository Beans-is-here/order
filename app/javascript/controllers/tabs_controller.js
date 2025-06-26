import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ["tab"]

  change(event) {
    const tab = event.currentTarget.dataset.tab

    // 選択状態のスタイル切り替え
    this.tabTargets.forEach(button => {
      button.classList.remove("font-bold", "text-gray-700")
      button.classList.add("text-gray-500")
    })
    event.currentTarget.classList.add("font-bold", "text-gray-700")

    // タブに応じた注文一覧を取得 (Turbo Frameにて)
    Turbo.visit(`/orders?tab=${tab}`, { frame: "order-list" })
  }
}
