class String

	def format_title
		tmp = self[2..-1].split("_").join(" ").split(":").join("/")
		tmp[".html"] = "" if tmp[".html"]
		tmp
	end

  def localized(value=nil, table=nil)
    @localized = NSBundle.mainBundle.localizedStringForKey(self, value:value, table:table)
  end
  alias _ localized

end
