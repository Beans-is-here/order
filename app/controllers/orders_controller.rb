class OrdersController < ApplicationController
=begin
  def index
    @orders = Order.includes(:user)
  end
=end
=begin
  def index
    @orders = current_user.orders.includes(:menu => :store).order(ordered_at: :desc)
  end
=end

  def index
    @tab = params[:tab]

    @orders = case @tab
              when "ordered"
                current_user&.orders&.where(ordered: true)
              when "wanted"
                current_user&.orders&.where(ordered: false)
              else
                current_user&.orders
              end

    respond_to do |format|
      format.html
      format.turbo_stream do
        html = render_to_string(
          partial: "orders/list",
          formats: [:html],
          locals: { orders: @orders }
        )
        render turbo_stream: turbo_stream.update("order-list", html)
      end
    end
  end

  def new
    @order = Order.new
  end
end