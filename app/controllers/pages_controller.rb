# conding: utf-8
class PagesController < ApplicationController
  def home
		@title = "Главная"
  end

  def contact
		@title = "Contacts"
  end

end
