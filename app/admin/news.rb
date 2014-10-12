ActiveAdmin.register News do
  config.comments = false
  config.batch_actions = false

  index download_links: false do
    column :id
    column :content
    column :title
    column :publish_date
    column :end_date

    default_actions
  end

  form do |f|
    f.inputs t('news') do
      f.input :title
      f.input :content
      f.input :publish_date, as: :datepicker
      f.input :end_date, as: :datepicker
    end
    f.actions
  end

end
