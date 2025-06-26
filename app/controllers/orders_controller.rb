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
    @order = Order.new
  end

  def create
    ActiveRecord::Base.transaction do
      # 店名取得 or 登録
      store = Store.find_or_create_by!(name: params[:order][:store]) do |s|
        s.user = current_user
      end

      # メニューの取得 or 登録
      menu = Menu.find_or_create_by!(name: params[:order][:menu], store: store)

      # orderの登録
      @order = current_user.orders.build(
        menu: menu,
        ordered: ActiveModel::Type::Boolean.new.cast(params[:order][:ordered]),
        ordered_at: Time.current,
        memo: params[:order][:memo]
      )

      @order.save!

      if params[:order][:rating].present?
        Review.create!(
          user: current_user,
          menu: menu,
          rating: params[:order][:rating]
        )
      end

      if params[:order][:image_url].present?
        menu.image_url = params[:order][:image_url]
        menu.save!
      end
puts "uploaded URL: #{menu.image_url.url}"
      redirect_to orders_path, success: t('defaults.flash_message.created', item: Order.model_name.human)
    rescue ActiveRecord::RecordInvalid => e
      flash.now[:danger] = t('defaults.flash_message.not_created', item: Order.model_name.human)
      @order ||= current_user.orders.build
      render :new, status: :unprocessable_entity
    end
  end
end