class DetailScreen < PM::Screen

  attr_accessor :name, :path

  def on_init
    self.setTitle self.name
  end

  def will_appear
    @view_loaded ||= begin

      ap self.path
      self.view = UIWebView.new

      content_string = File.read(self.path)
      baseURL = NSURL.fileURLWithPath(App.resources_path)

      #Convert images over to retina if the images exist.
      if Device.retina?
        aboutContent.gsub!(/src=['"](.*)\.(jpg|gif|png)['"]/) do |img|
          if File.exists?(App.resources_path + "/#{$1}@2x.#{$2}")
            # Create the image only so that we can get its actual size
            uiImage = UIImage.imageNamed("/#{$1}@2x.#{$2}")

            newWidth = uiImage.size.width / 2
            newHeight = uiImage.size.height / 2

            img = "src=\"#{$1}@2x.#{$2}\" width=\"#{newWidth}\" height=\"#{newHeight}\""
          end
        end
      end

      # Prepend the stylesheet to the html document before displaying.
      content_string = '<link href="style.css" rel="stylesheet" type="text/css" />' + content_string

      self.view.loadHTMLString(content_string, baseURL:baseURL)
    end
  end

end
