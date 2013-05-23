class Detail < PM::Screen

  attr_accessor :name, :path

  def on_init
    self.setTitle self.name
  end

  def will_appear
    @view_loaded ||= begin

      ap self.path
      self.view = UIWebView.new
      request = NSURLRequest.requestWithURL(NSURL.fileURLWithPath(self.path))
      self.view.loadRequest request
    end
  end

end
