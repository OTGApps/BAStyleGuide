class String

	def format_title
		tmp = self[2..-1].split("_").join(" ")
		tmp[".txt"] = "" if tmp[".txt"]
		tmp
	end

end
