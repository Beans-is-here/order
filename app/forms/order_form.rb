class OrderForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  extend CarrierWave::Mount

  mount_uploader :menu_image_url, MenuImageUploader

  attribute :ordered, :boolean
  attribute :store_name, :string
  attribute :menu_name, :string
  attribute :review_rating, :integer
  attribute :memo, :string
  attribute :menu_image_url, :string

  validates :store_name, :menu_name, presence: true
  validates :memo, length: { maximum: 40 }

  attr_reader :user
  attr_accessor :order

  delegate :persisted?, to: :order, allow_nil: true

  def initialize(attributes = nil, user:, order: nil)
    @user = user
    @order = order
    attributes ||= default_attributes
    super(attributes)
  end

  def save
    Rails.logger.debug '=== saveメソッド開始 ==='
    Rails.logger.debug { "valid?の結果: #{valid?}" }
    return false unless valid?

    Rails.logger.debug '=== transaction開始 ==='

    ActiveRecord::Base.transaction do
      Rails.logger.debug '=== Store作成開始 ==='
      Rails.logger.debug { "store_name: #{store_name.inspect}" }

      begin
        store = Store.find_or_create_by!(name: store_name, user: user)
        Rails.logger.debug { "Store作成完了: #{store.id}" }
      rescue StandardError => e
        Rails.logger.debug { "Store作成エラー: #{e.message}" }
        raise e # エラーを再発生させる
      end
      menu = Menu.create!(
        name: menu_name,
        image_url: menu_image_url,
        store: store
      )
      Rails.logger.debug '=== 画像デバッグ ==='
      Rails.logger.debug { "menu_image_url: #{menu_image_url.inspect}" }
      Rails.logger.debug { "menu_image_url.present?: #{menu_image_url.present?}" }
      Rails.logger.debug { "menu_image_url.class: #{menu_image_url.class}" }
      Rails.logger.debug '=== mount_uploaderが使えるか ==='
      Rails.logger.debug { "respond_to mount_uploader: #{respond_to?(:mount_uploader)}" }
      @order = user.orders.create!(
        menu: menu,
        memo: memo,
        ordered: ordered,
        ordered_at: ordered ? Time.current : nil
      )

      if review_rating.present?
        menu.reviews.create!(
          user: user,
          rating: review_rating
        )
      end
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    e.record.errors.full_messages.each do |message|
      errors.add(:base, message)
    end
    false
  end

  def update
    Rails.logger.debug '=== updateメソッド開始 ==='
    Rails.logger.debug { "valid?の結果: #{valid?}" }
    return false unless valid?

    Rails.logger.debug '=== transaction開始 ==='
    ActiveRecord::Base.transaction do
      Rails.logger.debug '=== Store作成開始 ==='
      Rails.logger.debug { "store_name: #{store_name.inspect}" }

      store = Store.find_or_create_by!(name: store_name, user: user)
      menu = order.menu
      menu.update!(
        name: menu_name,
        image_url: menu_image_url,
        store: store
      )

      order.update!(
        memo: memo,
        ordered: ordered,
        ordered_at: ordered ? Time.current : nil
      )

      review = menu.reviews.find_or_initialize_by(user: user)
      review.update!(rating: review_rating) if review_rating.present?
    end

    true
  rescue ActiveRecord::RecordInvalid => e
    e.record.errors.full_messages.each do |message|
      errors.add(:base, message)
    end
    false
  end

  private

  def default_attributes
    return {} unless order

    {
      ordered: order.ordered,
      store_name: order.menu.store.name,
      menu_name: order.menu.name,
      review_rating: order.menu.reviews.find_by(user: user)&.rating,
      memo: order.memo,
      menu_image_url: order.menu.image_url
    }
  end
end
