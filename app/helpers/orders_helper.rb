module OrdersHelper
  def status_toggle_button(order, current_tab)
    button_to '注文済みにする',
              update_status_order_path(order, tab: current_tab),
              method: :patch,
              form: { data: { turbo_stream: true } },
              data: {
                confirm: '注文済みに変更しますか？'
              },
              class: 'bg-amber-500 hover:bg-orange-500 text-white px-2 py-1 ' \
                     'rounded-md text-xs font-medium transition-colors duration-200 ' \
                     'focus:outline-none focus:ring-2 focus:ring-amber-500 ' \
                     'focus:ring-offset-1 hover:shadow-sm',
              title: '注文状態を変更'
  end
end
