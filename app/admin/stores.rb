ActiveAdmin.register Store do
  index do
    selectable_column
    id_column

    column :user_id
    column :name
    column :created_at
    column :updated_at
  end
  filter :user_id
  filter :name
  filter :created_at
  filter :updated_at
end
