# coding: utf-8
class PagesController < ApplicationController
  # skip_before_filter :authenticate, :only => [:home, :about, :help]
  def home
		@title = "Главная"
    @news = News.active
  end

  def contact
		@title = "Контакты"
  end

  def help
    @title = "Помощь"
  end

end
