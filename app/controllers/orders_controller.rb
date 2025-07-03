class OrdersController < ApplicationController
  def index
    @tab = params[:tab]

    @orders = case @tab
              when "ordered"
                current_user.orders.includes(menu: :store).where(ordered: true)
              when "wanted"
                current_user.orders.includes(menu: :store).where(ordered: false)
              else
                current_user.orders.includes(menu: :store)
              end

    @orders = @orders.includes(menu: :store).order(ordered_at: :desc).page(params[:page])

    respond_to do |format|
      format.html
    end
  end

  def new
    @order = OrderForm.new(user: current_user)
  end

  def create
    @order = OrderForm.new(order_params, user: current_user)

    if @order.save
      redirect_to orders_path, success: t('defaults.flash_message.created', item: Order.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Order.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def update_status
    @order = current_user.orders.find(params[:id])
    @order.update!(ordered: true, ordered_at: Time.current)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to orders_path(tab: "ordered"), notice: "注文済みに更新しました" }
    end
  end

  def edit
   # @order = OrderForm.new(order: @order, user: current_user)
   @order = OrderForm.new(order: Order.find(params[:id]), user: current_user)
  end

  def update
    existing_order = Order.find(params[:id])
    @order = OrderForm.new(order: existing_order, user: current_user)
    # 既存のOrderを渡す必要がある
    @order.assign_attributes(order_params)

    if @order.update
      redirect_to orders_path
    else
      render :edit
    end
  end

  def destroy
    order = current_user.orders.find(params[:id])
    order.destroy
    redirect_to orders_path
  end

  private

  def order_params
    params.require(:order_form).permit(
      :store_name,
      :menu_name,
      :ordered,
      :memo,
      :review_rating,
      :menu_image_url
    )
  end
end