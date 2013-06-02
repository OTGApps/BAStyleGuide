class String

	def format_title
		tmp = self[2..-1].split("_").join(" ").split(":").join("/")
		tmp[".html"] = "" if tmp[".html"]
		tmp
	end

end
