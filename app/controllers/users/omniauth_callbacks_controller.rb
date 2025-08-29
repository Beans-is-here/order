class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter2
    callback_from :twitter2
  end

  private

  def callback_from(provider)
    provider = provider.to_s

    @user = User.twitter_oauth(request.env['omniauth.auth'])

    if @user.persisted?
      flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize)
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.#{provider}_data"] = request.env['omniauth.auth']
      redirect_to root_path
    end
  end
end