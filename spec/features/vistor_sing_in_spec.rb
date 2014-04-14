require 'spec_helper'

describe "integration tests" do
  let(:user) { FactoryGirl.create :user }

  it 'Visitor sign in page' do
    visit signin_path
    expect(page).to have_content('E-mail')
    expect(page).to have_content('Пароль')
  end

  it 'Visitor sign in action' do
    visit signin_path
    #within(".field") do
      fill_in 'E-mail', with: user.email
      fill_in 'Пароль', with: user.password
    #end
    click_button 'Вход'
    expect(page).to have_content(user.name)

  end

end
