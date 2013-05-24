class DetailScreen < PM::Screen

  attr_accessor :name, :path

  def on_init
    self.setTitle self.name
  end

  def will_appear
    @view_loaded ||= begin

      ap self.path
      self.view = UIWebView.new

      baseURL = NSURL.fileURLWithPath(App.resources_path)
      self.view.loadHTMLString(File.read(self.path), baseURL:baseURL)
    end
  end

end
