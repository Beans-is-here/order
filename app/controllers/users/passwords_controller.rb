# frozen_string_literal: true

module Users
  class PasswordsController < Devise::PasswordsController
    # GET /resource/password/new
    def new
      super
    end

    # GET /resource/password/edit?reset_password_token=abcdef
    def edit
      super
    end

    # POST /resource/password
    def create
      self.resource = resource_class.new
      email = resource_params[:email]

      if email.blank?
        resource.errors.add(:email, :blank)
        render :new, status: :unprocessable_entity
        return
      end

      unless email.match?(URI::MailTo::EMAIL_REGEXP)
        resource.errors.add(:email, :invalid)
        render :new, status: :unprocessable_entity
        return
      end
      # a@a など不正な値に対するバリデーショnAエラーも今後入れたい。

      user = User.find_by(email: email)

      if user
        user.send_reset_password_instructions
        Rails.logger.info "Password reset instructions sent to #{email}"
      else
        Rails.logger.info "Password reset attempted for non-existent email: #{email}"
      end

      set_flash_message!(:notice, :send_instructions)
      redirect_to after_sending_reset_password_instructions_path_for(resource_name)
    end

    # PUT /resource/password
    def update
      super
    end

    private

    def resource_params
      params.require(:user).permit(:email)
    end

    # protected

    # def after_resetting_password_path_for(resource)
    #   super(resource)
    # end

    # The path used after sending reset password instructions
    # def after_sending_reset_password_instructions_path_for(resource_name)
    #   super(resource_name)
    # end
  end
end
