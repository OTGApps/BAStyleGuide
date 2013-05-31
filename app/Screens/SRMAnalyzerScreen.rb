class SRMAnalyzerScreen < PM::Screen

  title "SRM Analyzer"

  def will_appear
    @view_loaded ||= begin
      @captureManager = CaptureSessionManager.new
      @captureManager.addVideoInput
      @captureManager.addVideoPreviewLayer

      layerRect = self.view.layer.bounds
      @captureManager.previewLayer.setBounds(layerRect)
      @captureManager.previewLayer.setPosition(CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect)))

      view.layer.addSublayer(@captureManager.previewLayer)

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

      @captureManager.captureSession.startRunning
    end
  end

  def scanButtonPressed
    @scanningLabel.setHidden(false)
    self.performSelector("hideLabel:", withObject:@scanningLabel, afterDelay:2)
  end

  def hideLabel(label)
    label.setHidden(true)
  end

end
