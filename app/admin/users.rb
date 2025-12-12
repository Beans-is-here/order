ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :provider, :uid, :username, :role
  #
  # or
  #
  # permit_params do
  #   permitted = [:name, :email, :encrypted_password, :reset_password_token, :reset_password_sent_at, :remember_created_at, :provider, :uid, :username, :role]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  index do
    selectable_column
    id_column

    column :email
    column :name
    column :created_at
    column :updated_at
  end
  filter :email
  filter :name
  filter :created_at
  filter :updated_at
  remove_filter :reset_password_token
  remove_filter :reset_password_sent_at
  remove_filter :encrypted_password
end
