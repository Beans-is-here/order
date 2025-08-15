# fat controllerを懸念してform objectへ書き出し。
class OrderSearch
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :store_name, :string
  attribute :menu_name, :string
  attribute :ordered, :boolean
  attribute :keyword, :string

  attr_reader :user, :tab

  # 検索前に初期化
  def initialize(attributes = {}, user:, tab: "all") 
    @user = user
    @tab = tab
    puts "[FORM OBJECT DEBUG] 初期化時のattributes: #{attributes.inspect}"
    puts "[FORM OBJECT DEBUG] 初期化時のtab: #{@tab}"
    puts "[FORM OBJECT DEBUG] 初期化時のuser: #{@user}"
    super(attributes)
    puts "[FORM OBJECT DEBUG] 初期化後のkeyword: #{keyword.inspect}"
  end

  def results
    puts "[FORM OBJECT DEBUG] results実行時のtab: #{@tab.inspect}"
    scope = user.orders.includes(menu: :store)

    case @tab
    when "ordered"
      scope = scope.where(ordered: true)
    when "wanted"
      scope = scope.where(ordered: false)
 #   "all"の場合は絞り込みなし
    end

    puts "[FORM OBJECT DEBUG] タブ適用後のscope: #{scope.to_sql}"

    if keyword.present?
      normalized = Normalizer.normalize_name(keyword)
      scope = scope.joins(menu: :store).where(
        "menus.name_normalized ILIKE :kw OR stores.name_normalized ILIKE :kw",
        kw: "%#{normalized}%"
      )
    end

    puts "[DEBUG] user経由でのorders: #{user.orders.count}"
    scope
  end

  def autocomplete_suggestions(query, limit: 5)
    return [] if query.blank?
    puts "[AUTOCOMPLETE DEBUG] 受信したクエリ: #{query.inspect}"
    normalized = Normalizer.normalize_name(query.strip)
    puts "[AUTOCOMPLETE DEBUG] 正規化後のクエリ: #{normalized.inspect}"

    begin
    # menuで検索
    menu_suggestions = menu_suggestions(normalized, limit / 2)
    puts "[AUTOCOMPLETE DEBUG] メニュー候補: #{menu_suggestions.inspect}"

    # store
    store_suggestions = store_suggestions(normalized, limit /2)
    puts "[AUTOCOMPLETE DEBUG] 店舗候補: #{store_suggestions.inspect}"

    # result
    result = (menu_suggestions + store_suggestions).uniq { |item| [item[:text], item[:store]] }.first(limit)
    puts "[AUTOCOMPLETE DEBUG] 最終結果: #{result.inspect}"

     #明示的に結果を返す
      puts "[AUTOCOMPLETE DEBUG] メソッド正常終了"
      return result
      
    rescue => e
      puts "[AUTOCOMPLETE ERROR] 例外が発生しました: #{e.class}: #{e.message}"
      puts "[AUTOCOMPLETE ERROR] バックトレース: #{e.backtrace.join("\n")}"
      # 例外が発生した場合は空配列を返す
      return []
    end
  end

  private

  #attr_reader :user, :tab

  def menu_suggestions(normalized_query, limit)
    user.orders
        .joins(menu: :store)
        .where("menus.name_normalized ILIKE ?", "%#{normalized_query}%")
        .select("DISTINCT menus.name, stores.name as store_name")
        .limit(limit)
        .map do |result|
          {
            text: result.name,
            type: 'menu',
            store: result.store_name
          }
        end
  end

  def store_suggestions(normalized_query, limit)
    user.orders
        .joins(menu: :store)
        .where("stores.name_normalized ILIKE ?", "%#{normalized_query}%")
        .select("DISTINCT stores.name as store_name")
        .limit(limit)
        .map do |result|
          {
            text: result.store_name,
            type: 'store',
            store: result.store_name
          }
        end
  end
end