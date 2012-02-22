# coding: utf-8
class PagesController < ApplicationController
  def home
		@title = "Главная"
  end

  def contact
		@title = "Контакты"
  end

end
