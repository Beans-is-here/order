# fat controllerを懸念してform objectへ書き出し。
class OrderSearch
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :store_name, :string
  attribute :menu_name, :string
  attribute :ordered, :boolean

  attr_reader :user

  def initialize(attributes = {}, user:) 
    @user = user
    super(attributes)
  end

  def results
    scope = Order.includes(menu: :store).where(user_id: user.id)

    scope = scope.where(ordered: ordered) unless ordered.nil?
    normalized = Normalizer.normalize_name(menu_name)
    scope = scope.references(:menus).where("menus.name_normalized ILIKE ?", "%#{normalized}%")
    normalized = Normalizer.normalize_name(store_name)
    scope = scope.references(:stores).where("stores.name_normalized ILIKE ?", "%#{normalized}%")
    
    puts "[DEBUG] ordered: #{ordered.inspect}, store_name: #{store_name.inspect}, menu_name: #{menu_name.inspect}"
    puts "[DEBUG] SQL: #{scope.to_sql}"
    puts "[DEBUG] tab: #{@tab.inspect}, ordered: #{ordered.inspect}, store_name: #{store_name.inspect}, menu_name: #{menu_name.inspect}"

    scope
  end
end