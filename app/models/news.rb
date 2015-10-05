class News < ActiveRecord::Base
  # attr_accessible :content, :end_date, :title, :publish_date

  def self.active
    News.where("end_date > ?", Time.now.to_date).order("publish_date DESC")
  end
end
