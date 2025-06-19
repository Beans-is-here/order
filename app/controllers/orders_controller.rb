class OrdersController < ApplicationController
  def index
    @orders = Order.includes(:user)
  end
end
