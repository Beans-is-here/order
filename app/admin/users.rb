ActiveAdmin.register User do
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
