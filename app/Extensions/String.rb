class String

	def format_title
		tmp = self.copy
    tmp = tmp[2..-1] if self[2] == "_"
    tmp = tmp.split("_").join(" ").split(":").join("/")
		tmp[".html"] = "" if tmp[".html"]
		tmp
	end

  def localized(value=nil, table=nil)
    @localized = NSBundle.mainBundle.localizedStringForKey(self, value:value, table:table)
  end
  alias _ localized

end
