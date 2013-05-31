class SRMAnalyzerScreen < PM::Screen

  title "SRM Analyzer"

  attr_accessor :vImagePreview, :stillImageOutput, :vImage

  def will_appear
    @view_loaded ||= begin

      # UIView Setup
      view.setBackgroundColor UIColor.whiteColor
      set_nav_bar_left_button "Done", action: :close_modal, type: UIBarButtonItemStyleDone

      # accessors setup
      self.vImagePreview = add UIView.alloc.initWithFrame(view.frame)
      self.stillImageOutput = AVCaptureStillImageOutput.new

      # Camera View Setup
      @session = AVCaptureSession.alloc.init
      @session.sessionPreset = AVCaptureSessionPresetMedium

      viewLayer = self.vImagePreview.layer

      captureVideoPreviewLayer = AVCaptureVideoPreviewLayer.alloc.initWithSession(@session)

      captureVideoPreviewLayer.frame = self.vImagePreview.bounds
      self.vImagePreview.layer.addSublayer(captureVideoPreviewLayer)

      device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)

      error_ptr = Pointer.new(:object)
      input = AVCaptureDeviceInput.deviceInputWithDevice(device, error:error_ptr)
      error = error_ptr #De-reference the pointer.
      if !input
        # Handle the error appropriately.
        NSLog("ERROR: trying to open camera: %@", error)
      else
        @session.addInput(input)
        self.stillImageOutput.setOutputSettings({AVVideoCodecKey: AVVideoCodecJPEG})

        @session.addOutput(stillImageOutput)

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


      # overlayImageView = UIImageView.alloc.initWithImage(UIImage.imageNamed("overlaygraphic.png"))
      # overlayImageView.setFrame(CGRectMake(30, 100, 260, 200))
      # view.addSubview(overlayImageView)

      # overlayButton = UIButton.buttonWithType(UIButtonTypeCustom)
      # overlayButton.setImage(UIImage.imageNamed("scanbutton.png"), forState:UIControlStateNormal)
      # overlayButton.setFrame(CGRectMake(130, 320, 60, 30))
      # overlayButton.addTarget(self, action:"scanButtonPressed", forControlEvents:UIControlEventTouchUpInside)
      # self.view.addSubview(overlayButton)

      # tempLabel = UILabel.alloc.initWithFrame(CGRectMake(100, 50, 120, 30))
      # @scanningLabel = tempLabel
      # @scanningLabel.setBackgroundColor(UIColor.clearColor)
      # @scanningLabel.setFont(UIFont.fontWithName("Courier", size:18.0))
      # @scanningLabel.setTextColor(UIColor.redColor)
      # @scanningLabel.setText("Scanning...")
      # @scanningLabel.setHidden(true)

      # view.addSubview(@scanningLabel)

      # @captureManager.captureSession.startRunning
    end
  end

  def will_disappear
    if !@session.nil? && @session.respond_to?("running") && @session.running == true
      @session.stopRunning
    end
  end

  def captureNow
    videoConnection = nil
    stillImageOutput.connections.each do |connection|
      connection.inputPorts.each do |port|
        if port.mediaType == AVMediaTypeVideo
          videoConnection = connection
          break
        end
      end
      break if videoConnection
    end

    NSLog("about to request a capture from: %@", stillImageOutput)
    stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler:lambda do |imageSampleBuffer, error|
      exifAttachments = CMGetAttachment( imageSampleBuffer, KCGImagePropertyExifDictionary, nil)
      if exifAttachments
        # Do something with the attachments.
        NSLog("attachements: %@", exifAttachments)
      else
        NSLog("no attachments")
      end

      imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageSampleBuffer)
      image = UIImage.alloc.initWithData(imageData)

      self.vImage = image
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
