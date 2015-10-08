ActiveAdmin.register User do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :name, :email, :is_block, :admin, :manager
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end

  index download_links: false do
    column :id
    column :name
    column :email
    column :company
    column :is_block
    column :admin
    column :manager

    actions
  end

  form do |f|
    f.inputs t('user') do
      f.input :name
      f.input :email
      f.input :company
      f.input :is_block
      f.input :admin
      f.input :manager

    end
    f.actions
  end

end
