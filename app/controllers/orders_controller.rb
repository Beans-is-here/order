class OrdersController < ApplicationController
  def index
    puts @recommendation_checked #必ずnilとなる
    # before_actionでcheck_recommendationが実行される
    puts @recommendation_checked # trueになる
    @tab = params[:tab].presence || "all"
    @sort = params[:sort].presence || "latest"

    @orders = current_user.orders.includes(menu: :store)

    case @tab
    when "ordered"
      @orders = @orders.where(ordered: true)
    when "wanted"
      @orders = @orders.where(ordered: false)
    else 
      @orders
    end

    # search form
    if params[:search].present?
      keyword = params.dig(:search, :keyword).to_s
      unless keyword.blank?
        normalized = Normalizer.normalize_name(keyword)
        @orders = @orders.joins(menu: :store).where(
          "menus.name_normalized ILIKE :kw OR stores.name_normalized ILIKE :kw",
          kw: "%#{normalized}%"
        )
      end
    end

    #count
    @count_all = @orders.count
    @count_ordered = @orders.where(ordered: true).count
    @count_wanted = @orders.where(ordered: false).count
    
    @orders = case @sort
              when "latest"
                @orders.latest
              when "old"
                @orders.old
              else
                @orders.latest
              end

    @orders = @orders.page(params[:page])

    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace("order-list", partial: "orders/list", locals: { orders: @orders }) }
    end
        # デバッグ用ログ
    Rails.logger.info "=== Orders#index ==="
    Rails.logger.info "セッション: #{session[:recommendation_id]}"
    Rails.logger.info "ユーザー: #{current_user&.id}"
    Rails.logger.info "=================="
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

    #flash.nowからformat.turbo_stream?　要確認!!
    flash.now[:notice] = "オーダー済みに更新しました"

    #気になったタブからのステータス変更用
    respond_to do |format|
      #update_status.turbo_streamをレンダリング
      format.turbo_stream
      format.html { redirect_to orders_path(tab: "ordered"), notice: "オーダー済みに更新しました" }
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