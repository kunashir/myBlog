module  UserHelper

  def login(a, ps)
    visit signin_path
    #within("#session") do
      fill_in 'E-mail', :with => a.email
      fill_in 'Пароль', :with => a.password
    #end
    click_button 'Вход'
  end
end