class OrdersController < ApplicationController
=begin
  def index
    @orders = Order.includes(:user)
  end
=end

  def index
    @orders = current_user.orders.includes(:menu => :store).order(ordered_at: :desc)
  end
end
