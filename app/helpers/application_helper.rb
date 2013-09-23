#coding: utf-8
module ApplicationHelper
	def title
		base_title = "Реестр перевозок"
		if @title.nil?
			base_title
		else
			"#{base_title} | #{@title}"
		end
	end

	def logo
		image_tag("logo.jpg", :size => "500x105", :alt => "Лого", :class => "img-rounded")
	end
  
  def track_logo
    image_tag("tr.png", :size => "50x35", :alt => "Ваша ставка лучшая", :class => "round")
  end
  
  def lock_logo
  	image_tag("lock.jpeg", :size => "25x25", :alt => "Заявка заркылась", :class => "round")
  end
  
  def to_time ( m_time )
                    # => Thu Jan 18 06:10:17 CST 2007

   # m_time.to_s ( Time::DATE_FORMATS[:short_ordinal] = lambda { |time| time.strftime("%B #{time.day.ordinalize}") })
    if !m_time.nil?
    	m_time.to_formatted_s(:time)
    end
  end
end
