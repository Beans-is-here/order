class Users::SessionsController < Devise::SessionsController
  def guest_sign_in
    user = User.find_or_create_by!(email: 'guest@example.com') do |user|
      user.name = 'ゲストユーザー'
      user.password = 'Guest0Password'
      user.password_confirmation = user.password
    end

    sign_in user
    redirect_to root_path, notice: 'ゲストユーザーとしてログインしました'
  end
end