class OrdersController < ApplicationController
  def index
    Rails.logger.debug @recommendation_checked # 必ずnilとなる
    # before_actionでcheck_recommendationが実行される
    Rails.logger.debug @recommendation_checked # trueになる
    @tab = params[:tab].presence || 'all'
    @sort = params[:sort].presence || 'latest'

    @orders = current_user.orders.includes(menu: :store)

    # ===== デバッグ情報を追加 =====
    Rails.logger.info '=== パラメータデバッグ ==='
    Rails.logger.info "全params: #{params.inspect}"
    Rails.logger.info "params[:search]: #{params[:search].inspect}"
    Rails.logger.info "search_params: #{search_params.inspect}"
    Rails.logger.info '=========================='

    Rails.logger.debug { "[CONTROLLER DEBUG] 全params: #{params.inspect}" }
    Rails.logger.debug { "[CONTROLLER DEBUG] params[:search]: #{params[:search].inspect}" }
    Rails.logger.debug { "[CONTROLLER DEBUG] search_params: #{search_params.inspect}" }

    # search　タブ移動、フォーム共通
    @order_search = OrderSearch.new(search_params, user: current_user, tab: @tab)
    @orders = @order_search.results

    # count
    @count_all = @orders.count
    @count_ordered = @orders.where(ordered: true).count
    @count_wanted = @orders.where(ordered: false).count

    @orders = case @sort
              when 'old' then @orders.old
              else @orders.latest
              end

    @orders = @orders.page(params[:page])

    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('order-list', partial: 'orders/list',
                                                                locals: { orders: @orders })
      end
    end
    # デバッグ用ログ
    Rails.logger.info '=== Orders#index ==='
    Rails.logger.info "セッション: #{session[:recommendation_id]}"
    Rails.logger.info "ユーザー: #{current_user&.id}"
    Rails.logger.info '=================='
  end

  def autocomplete
    Rails.logger.info '=== Orders#autocomplete ==='
    query = params[:q]&.strip

    Rails.logger.info "受信したクエリ: #{query.inspect}"

    # form objectで処理
    order_search = OrderSearch.new({}, user: current_user)
    suggestions = order_search.autocomplete_suggestions(query)

    Rails.logger.info "生成された候補: #{suggestions.inspect}"

    # stimulus-autocompleteの形式
    #    formatted_suggestions = suggestions.map do |suggestion|
    #      {
    #        label: "#{suggestion[:text]} (#{suggestion[:store]})", #表示テキスト
    #        value: suggestion[:text] #選択時に入力される値
    #      }
    menus_data = suggestions.map do |suggestion|
      {
        name: suggestion[:text],
        store: { name: suggestion[:store] }
      }
    end

    #    Rails.logger.info "フォーマット後の候補: #{formatted_suggestions.inspect}"
    #    render json: formatted_suggestions
    render partial: 'autocomplete_results', locals: { menus: menus_data }
  end

  def new
    @order = OrderForm.new(user: current_user)
  end

  def edit
    # @order = OrderForm.new(order: @order, user: current_user)
    @order = OrderForm.new(order: Order.find(params[:id]), user: current_user)
  end

  def create
    @order = OrderForm.new(order_params, user: current_user)

    if @order.save
      redirect_to orders_path,
                  success: t('defaults.flash_message.created', item: Order.model_name.human)
    else
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Order.model_name.human) # 'を入力してください'
      render :new, status: :unprocessable_entity
    end
  end

  def update_status
    @order = current_user.orders.find(params[:id])
    @order.update!(ordered: true, ordered_at: Time.current)

    # flash.nowからformat.turbo_stream?　要確認!!
    flash.now[:notice] = t('flash.orders.update_status.success')

    # 気になったタブからのステータス変更用
    respond_to do |format|
      # update_status.turbo_streamをレンダリング
      format.turbo_stream
      format.html { redirect_to orders_path(tab: 'ordered'), notice: t('flash.orders.update_status.success') }
    end
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

  def search_params
    # params.fetch(:search, {}).permit(:keyword)　# hashメソッド
    result = params.fetch(:search, {}).permit(:keyword)
    Rails.logger.debug { "[CONTROLLER DEBUG] search_paramsの結果: #{result.inspect}" }
    result
  end
end
