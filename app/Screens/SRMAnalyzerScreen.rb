class SRMAnalyzerScreen < PM::Screen

  title "SRM Analyzer"

  attr_accessor :live_preview, :still_image_output, :captured_image_preview

  def will_appear
    @view_loaded ||= begin

      # UIView Setup
      view.setBackgroundColor UIColor.whiteColor
      set_nav_bar_left_button "Done", action: :close_modal, type: UIBarButtonItemStyleDone

      # accessors setup
      video_ratio = 1.33333333333
      # video_width =
      self.live_preview = add UIView.new, {
        frame: CGRectMake(0, 0, self.view.size.width, self.view.size.width * video_ratio)
      }
      self.live_preview.setBackgroundColor UIColor.redColor
      self.still_image_output = AVCaptureStillImageOutput.new

      # Camera View Setup
      @session = AVCaptureSession.alloc.init
      @session.sessionPreset = AVCaptureSessionPresetLow

      captureVideoPreviewLayer = set_attributes AVCaptureVideoPreviewLayer.alloc.initWithSession(@session), {
        frame: self.live_preview.frame,
        background_color: UIColor.blueColor
      }

      self.live_preview.layer.addSublayer(captureVideoPreviewLayer)

      device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)

      error_ptr = Pointer.new(:object)
      input = AVCaptureDeviceInput.deviceInputWithDevice(device, error:error_ptr)
      error = error_ptr #De-reference the pointer.
      if !input
        # Handle the error appropriately.
        NSLog("ERROR: trying to open camera: %@", error)
      else
        @session.addInput(input)
        self.still_image_output.setOutputSettings({AVVideoCodecKey: AVVideoCodecJPEG})

        @session.addOutput(still_image_output)
        @session.startRunning
      end

      #Create the gradient view.
      gradient_view_width = 100
      @gradient_view = add UIView.new, {
        frame: CGRectMake(view.frame.size.width-gradient_view_width, 0, gradient_view_width, self.view.frame.size.height),
      }
      @gradient_view.setBackgroundColor UIColor.whiteColor

      @gradient = CAGradientLayer.layer
      @gradient.frame = view.bounds
      @gradient.colors = SRM.spectrum

      @gradient_view.layer.insertSublayer(@gradient, atIndex:0)

      # Create the button
      @capture_button = add UIButton.buttonWithType(UIButtonTypeCustom), {
        frame: CGRectMake(10, self.view.frame.size.height - 83, 73, 73)
      }
      @capture_button.setBackgroundImage(UIImage.imageNamed("CaptureButton.png"), forState: UIControlStateNormal)
      @capture_button.setBackgroundImage(UIImage.imageNamed("CaptureButtonPressed.png"), forState: UIControlStateHighlighted)

      @capture_button.when(UIControlEventTouchUpInside) do
        captureNow
      end

      # Placeholder for captured image.
      self.captured_image_preview = add UIImageView.new, {
        frame: CGRectMake(self.view.frame.size.width - 100, self.view.frame.size.height - 100, 100, 100)
      }
      self.captured_image_preview.setBackgroundColor UIColor.orangeColor

      # Placeholder for average image color.
      @average_color = add UIView.new, {
        frame: CGRectMake(self.view.frame.size.width - 200, self.view.frame.size.height - 100, 100, 100)
      }
      @average_color.setBackgroundColor UIColor.greenColor

      # Add the target image over top of the live camera view.
      target_image = UIImage.imageNamed("srm_analyzer_target.png")
      @target_area = add UIImageView.alloc.initWithImage(target_image), {
        left: (self.live_preview.frame.size.width / 3) - (target_image.size.width/2),
        top: (self.live_preview.frame.size.height / 2) - (target_image.size.height/2),
        width: target_image.size.width,
        height: target_image.size.height
      }

      # tempLabel = UILabel.alloc.initWithFrame(CGRectMake(100, 50, 120, 30))
      # @scanningLabel = tempLabel
      # @scanningLabel.setBackgroundColor(UIColor.clearColor)
      # @scanningLabel.setFont(UIFont.fontWithName("Courier", size:18.0))
      # @scanningLabel.setTextColor(UIColor.redColor)
      # @scanningLabel.setText("Scanning...")
      # @scanningLabel.setHidden(true)

      # view.addSubview(@scanningLabel)

    end
  end

  def will_disappear
    if !@session.nil? && @session.respond_to?("running") && @session.running == true
      @session.stopRunning
    end
  end

  def captureNow
    videoConnection = nil
    still_image_output.connections.each do |connection|
      connection.inputPorts.each do |port|
        if port.mediaType == AVMediaTypeVideo
          videoConnection = connection
          break
        end
      end
      break if videoConnection
    end

    NSLog("about to request a capture from: %@", still_image_output)
    still_image_output.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler:lambda do |imageSampleBuffer, error|
      exifAttachments = CMGetAttachment( imageSampleBuffer, KCGImagePropertyExifDictionary, nil)
      if exifAttachments
        # Do something with the attachments.
        NSLog("attachements: %@", exifAttachments)
      else
        NSLog("no attachments")
      end

      imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
      image = UIImage.alloc.initWithData(imageData)

      ap "Got new image: #{image}"
      cropped = image.crop(CGRectMake(0, 0, 100, 100))
      self.captured_image_preview.image = cropped
      @average_color.setBackgroundColor cropped.averageColorAtPixel(CGPointMake(50, 50), radius:50.0)
     end)
  end

  def scanButtonPressed
    @scanningLabel.setHidden(false)
    self.performSelector("hideLabel:", withObject:@scanningLabel, afterDelay:2)
  end

  def hideLabel(label)
    label.setHidden(true)
  end

  def should_rotate(orientation)
    puts "Trying to determine rotation"
    UIDeviceOrientationPortrait == orientation
  end

  def should_autorotate
    puts "should autorotate?"
    false
  end

  def supported_orientations
    puts "checking supported orientations"
    orientations = 0
    orientations |= UIInterfaceOrientationMaskPortrait
    orientations
  end

  def close_modal
    close
  end

end
