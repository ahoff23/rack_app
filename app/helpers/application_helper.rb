module ApplicationHelper
	#Returns the full title of a page
	def full_title(page_title)
		base_title="Website Name"
		if page_title.empty?
			base_title
		else
			"#{base_title} | #{page_title}"
		end
	end
end
