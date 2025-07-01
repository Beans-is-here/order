module OrdersHelper
  def status_toggle_button(order, current_tab)
    button_to "注文した", update_status_order_path(order, tab: current_tab),
    method: :patch,
    form: { data: { turbo_stream: true}},
    class: "bg-amber-500 hover:bg-orange-300 text-white font-bold py-2 px-5 rounded focus:outline-none"
  end
end 