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

  form do |f|
    f.inputs t('rate') do
      f.input :area, :as => :select, :collection => Area.cities
      f.input :city, :collection => City.active #.map{|u| ["#{u.name}", u.id]}
      f.input :carcase, :collection => [['тент', 'тент'], ['термос', 'термос'], ['реф','реф']]
      f.input :summa
    end
    f.actions
  end

end
