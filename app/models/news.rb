class News < ActiveRecord::Base
  # attr_accessible :content, :end_date, :title, :publish_date

  def self.active
    News.where("end_date > ?", Time.now.to_date).order("publish_date DESC")
  end
end
# == Schema Information
#
# Table name: news
#
#  id           :integer         not null, primary key
#  title        :string(255)
#  content      :text
#  publish_date :date
#  end_date     :date
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

