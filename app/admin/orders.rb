ActiveAdmin.register Order do
  index do
    selectable_column
    id_column

    column :user_id
    column :menu_id
    column :memo
    column :created_at
    column :updated_at
  end
  filter :user_id
  filter :menu_id
  filter :memo
  filter :created_at
  filter :updated_at
end
