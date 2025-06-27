module OrdersHelper
  def status_toggle_button(order, current_tab)
    button_to "注文した", update_status_order_path(order, tab: current_tab),
    method: :patch,
    form: { data: { turbo_stream: true}},
    class: "text-sm underline text-gray-700 font-normal mt-3 hover:bg-gray-100"
  end
end
