import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

// Connects to data-controller="tabs"
export default class TabsController extends Controller {
  static targets = ["tab"]

  connect() {
    const defaultTab = this.tabTargets.find(tab => tab.dataset.tab === "all")
    if (defaultTab) this.setActiveTab(defaultTab)
  }

  change(event) {
    const tab = event.currentTarget.dataset.tab
    this.setActiveTab(event.currentTarget)

    const urlParams = new URLSearchParams(window.location.search)
    const currentSort = urlParams.get("sort") || "latest"
    const keyword = urlParams.get("search[keyword]") || ""

     // タブに応じた注文一覧を取得 (Turbo Frameにて)
     //Turbo.visit(`/orders?tab=${tab}&sort=${currentSort}`, { frame: "order-list" })
     const newUrl = `/orders?tab=${tab}&sort=${currentSort}&search[keyword]=${encodeURIComponent(keyword)}`
     Turbo.visit(newUrl, { frame: "order-list" })
    }

    // 選択状態のスタイル切り替え
  setActiveTab(activeTab) {  
    this.tabTargets.forEach(button => {
      button.classList.remove("font-bold", "text-white", "bg-orange-400", "shadow")
      button.classList.add("bg-gray-50", "text-gray-500")
    })

    activeTab.classList.remove("bg-gray-50", "text-gray-500")
    activeTab.classList.add("font-bold", "text-white", "bg-orange-400", "shadow")
  }
}
