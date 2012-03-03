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
		image_tag("logo.jpg", :alt => "Лого", :class => "round")
	end
end
