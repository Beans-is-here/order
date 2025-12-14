ActiveAdmin.register Menu do
  index do
    selectable_column
    id_column

    column :store_id
    column :name
    column :image_url
    column :created_at
    column :updated_at
  end
  filter :store_id
  filter :name
  filter :image_url
  filter :created_at
  filter :updated_at
end
