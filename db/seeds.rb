# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# user = User.find_or_create_by!(email: 'test@example.com') do |u|
#  u.name = "TESTuser"
#  u.password = 'password'
#  u.password_confirmation = 'password'
# end
#
# store = Store.find_or_create_by!(name: 'TESTお店', user: user)
#
# menus = []
# 5.times do |i|
#  menu = Menu.create(
#    name: "メニュー#{1 + i}",
#    store: store
#  )
#  menus << menu
# end
#
# menus.each_with_index do |menu, i|
#  Order.create!(
#    user: user,
#    menu: menu,
#    memo: "Oishi#{i + 1}",
#    ordered: i.even?,
#    ordered_at: Time.current - i.days
#  )
# end

User.find_or_create_by!(email: 'guest@example.com') do |user|
  user.name = 'ゲストユーザー'
  user.password = 'Guest0Password'
end
#AdminUser.create!(email: 'admin@order.com', password: 'passworD', password_confirmation: 'passworD') unless AdminUser.exists?

# 環境変数から管理者情報を取得。未設定の場合はデフォルト値を使用
admin_email = ENV.fetch('ADMIN_EMAIL', 'admin@order.com')
admin_password = ENV.fetch('ADMIN_PASSWORD', 'passworD')

# パスワードが空白でないことを確認してから作成
if admin_password.present?
  AdminUser.find_or_create_by!(email: admin_email) do |admin|
    admin.password = admin_password
    admin.password_confirmation = admin_password
    # Devise の :confirmable を使用している場合は、ここで confirmed_at も設定
    # admin.confirmed_at = Time.current
  end
  puts "AdminUser created/found: #{admin_email}"
else
  puts "WARNING: ADMIN_PASSWORD environment variable is missing, skipping AdminUser creation."
end