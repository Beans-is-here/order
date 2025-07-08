module OrdersHelper
  def status_toggle_button(order, current_tab)
    button_to "オーダーした", update_status_order_path(order, tab: current_tab),
    method: :patch,
    form: { data: { turbo_stream: true}},
    class: "bg-amber-500 hover:bg-orange-400 text-white px-1 rounded focus:outline-none"
  end
end 