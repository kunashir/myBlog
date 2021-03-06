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
		image_tag("horizont_logo.png", :size => "150x50", :alt => "Лого", :class => "round")
	end

  def track_logo
    image_tag("tr.png", :size => "50x35", :alt => "Ваша ставка лучшая", :class => "round")
  end

  def lock_logo
  	image_tag("lock.jpeg", :size => "25x25", :alt => "Заявка заркылась", :class => "round")
  end

  def copy_icon
    image_tag("tool_copy.png", :size => "15x15", :alt => "Копировать")
  end

  def remove_icon
    image_tag("grey_remove.png", :size => "15x15", :alt => "Удалить")
  end

  def close_icon
    image_tag("button_grey_close.png", :size =>"25x25", :alt => "Закрыть")
  end

  def to_time ( m_time )
                    # => Thu Jan 18 06:10:17 CST 2007

   # m_time.to_s ( Time::DATE_FORMATS[:short_ordinal] = lambda { |time| time.strftime("%B #{time.day.ordinalize}") })
    if !m_time.nil?
    	m_time.to_formatted_s(:time)
    end
  end

  def dt(date)
    return "&mdash;".html_safe if date.nil?
    begin
      return date.localtime.strftime('%d.%m.%Y %H:%M') if date.is_a? Time
      return date.strftime('%d.%m.%Y') if date.is_a? Date
    rescue
      return date
    end
  end
end
