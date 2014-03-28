ActiveAdmin.register Rate do
  menu parent: I18n.t('admin.rate')

  config.comments = false
  config.batch_actions = false

  index download_links: false do
    column :id
    column :city
    column :area
    column :carcase
    column :summa

    default_actions
  end
end
