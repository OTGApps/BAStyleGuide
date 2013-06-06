class StylesScreen < ProMotion::SectionedTableScreen
  title "Back"
  searchable :placeholder => "Search Styles"
  attr_accessor :torch_on

  def will_appear
    self.setTitle("orginization"._, subtitle:"version"._)

    set_attributes self.view, {
      backgroundColor: UIColor.whiteColor
    }

    set_nav_bar_right_button UIImage.imageNamed("info.png"), action: :open_info_screen
  end

  # def on_appear
  #   @opened_screen ||= begin
  #     open_srm_analyzer_screen
  #   end
  # end

  def table_data
  	@table_setup ||= begin
      s = []

      s << introduction_section
      s << judging_tools_section

      sections.each do |section|
    		s << {
    			title: section.format_title,
    			cells: build_cells(section)
    		}
    	end

      s
    end
  end

  def build_cells(path)
      c = []
    	section_listing(path).each do |style|
        c << {
    			title: style.format_title,
          cell_identifier: "StyleCell",
    			action: :open_style,
    			arguments: {:path => File.join(guidelines_path, path, style), :name => style.format_title}
    		}
    	end
  	 c
  end

  def judging_tools_section
    tools = {
      title: "Judging Tools",
      cells:
      [{
        title: "Flavor Wheel",
        cell_identifier: "ImagedCell",
        image: "flavor_wheel_thumb.png",
        action: :open_flavor_wheel,
        searchable: false
      },{
        title: "SRM Spectrum",
        cell_identifier: "ImagedCell",
        image: "srm_spectrum_thumb.png",
        action: :open_srm_screen,
        search_text: "color"
      },{
        title: "SRM Analyzer",
        cell_identifier: "ImagedCell",
        image: analyzer_image,
        action: :open_srm_analyzer_screen,
        search_text: "color"
      }]
    }

    tools[:cells] << torch_cell if torch_supported?

    tools
  end

  def analyzer_unlocked?
    true
  end

  def analyzer_image
    analyzer_unlocked? ? "eyedropper.png" : "lock.png"
  end

  def torch_supported?
    return true
    AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo).hasTorch
  end

  def torch_cell
    {
      title: "Clairity Analyzer",
      cell_identifier: "ImagedCell",
      image: analyzer_image,
      action: :torch_toggle,
      search_text: "light flashlight",
      accessory: :switch
    }
  end

  def accessory_toggled_switch(button)
    ap button
  end

  # def toggle_torch
  #   device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)

  #   if device.torchMode == AVCaptureTorchModeOff
  #     # Create an AV session
  #     session = AVCaptureSession.new

  #     # Create device input and add to current session
  #     input = AVCaptureDeviceInput.deviceInputWithDevice(device, error:nil)
  #     session.addInput(input)

  #     # Create video output and add to current session
  #     output = AVCaptureVideoDataOutput.new
  #     session.addOutput(output)

  #     # Start session configuration
  #     session.beginConfiguration
  #     device.lockForConfiguration(nil)

  #     # Set torch to on
  #     device.setTorchMode(AVCaptureTorchModeOn)

  #     device.unlockForConfiguration
  #     session.commitConfiguration

  #     # Start the session
  #     session.startRunning

  #     # Keep the session around
  #     self.setAVSession(session)
  #   else
  #     AVSession.stopRunning
  #     AVSession = nil
  #   end

  # end

  def toggle_torch
    # check if flashlight available
    captureDeviceClass = NSClassFromString("AVCaptureDevice")
    return false if captureDeviceClass.nil?

    device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    if device.hasTorch && device.hasFlash
      device.lockForConfiguration(nil)
      if self.torch_on
        device.setTorchMode(AVCaptureTorchModeOff)
        device.setFlashMode(AVCaptureFlashModeOff)
        self.torch_on = false
      else
        device.setTorchMode(AVCaptureTorchModeOn)
        device.setFlashMode(AVCaptureFlashModeOn)
        self.torch_on = true
      end
      device.unlockForConfiguration
    end
  end

  def introduction_section
    {
      title: nil,
      cells:
      [{
        title: "Introduction",
        cell_identifier: "ImagedCell",
        image: { image: UIImage.imageNamed("ba_logo_thumb.png") },
        action: :open_style,
        arguments: {
          :path => File.join(guidelines_path, "Introduction.html"),
          :name => "Introduction"
        }
      }]
    }
  end

  def open_style(args={})
  	open DetailScreen.new(args)
  end

  def open_info_screen(args={})
    open DetailScreen.new(
      :path => File.join(guidelines_path, "Info.html"),
      :name => "About"
    )
  end

  def open_flavor_wheel(args={})
    open FlavorWheelScreen.new
  end

  def open_srm_screen(args={})
    open SRMScreen.new
  end

  def open_srm_analyzer_screen(args={})
    if analyzer_unlocked?
      open SRMAnalyzerScreen.new, {modal:true, nav_bar:true}
    else
      open SRMAnalyzerDemoScreen.new
    end
  end

  def sections
  	# Returns all folder names
    Dir.entries(guidelines_path).select{|d|
      File.directory?(File.join(guidelines_path, d)) and not_dotfile(d)
  	}
  end

  def guidelines_path
  	File.join(App.resources_path, "guidelines")
	end

	def section_listing(category)
		path = File.join(guidelines_path, category)
    Dir.entries(path).select{|d|
  		!File.directory?(File.join(path, d)) and not_dotfile(d)
  	}
	end

  def not_dotfile(d)
    !(d =='.' || d == '..' || d[0] == '.')
  end

end
