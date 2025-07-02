import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ["tab"]

  connect() {
    const defaultTab = this.tabTargets.find(tab => tab.dataset.tab === "all")
    if (defaultTab) this.setActiveTab(defaultTab)
  }

  change(event) {
    const tab = event.currentTarget.dataset.tab
    this.setActiveTab(event.currentTarget)

     // タブに応じた注文一覧を取得 (Turbo Frameにて)
     Turbo.visit(`/orders?tab=${tab}`, { frame: "order-list" })
    }

    // 選択状態のスタイル切り替え
  setActiveTab(activeTab) {  
    this.tabTargets.forEach(button => {
      button.classList.remove("font-bold", "text-white", "bg-orange-400", "shadow")
      button.classList.add("bg-gray-100", "text-gray-500")
    })

    activeTab.classList.remove("bg-gray-100", "text-gray-500")
    activeTab.classList.add("font-bold", "text-white", "bg-orange-400", "shadow")
  }
}
