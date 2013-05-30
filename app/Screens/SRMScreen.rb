class SRMScreen < PM::Screen

  title "SRM Spectrum"

  def will_appear
    @view_loaded ||= begin
      # view.setBackgroundColor UIColor.redColor

      @srm_views ||= []
      steps = SRM.spectrum
      height = (self.view.frame.size.height) / steps.count

      @gradient = CAGradientLayer.layer
      @gradient.frame = view.bounds
      @gradient.colors = steps
      view.layer.insertSublayer(@gradient, atIndex:0)

      # steps.each_with_index do |srm_color, i|
      #   v = add UIView.new, {
      #     frame: CGRectMake(0, (height * i), self.view.frame.size.width, height),
      #     resize: [:width, :height, :top]
      #   }
      #   v.setBackgroundColor srm_color
      #   @srm_views << v
      # end

      view.when_panned do |gesture|
        got_touch_point gesture.locationInView(view.superview)
      end

    end
  end

  def got_touch_point(cgpoint)
    total_height = Device.screen.height_for_orientation(Device.orientation) - 44
    total_steps = SRM.major_steps.count + 1
    step_height = total_height / total_steps

    srm = (cgpoint.y / step_height).to_i + 1
    ap srm

    srm_string = "     #{srm.to_s}     "

    @indicators_initialized ||= begin
      @srm_indicator = CMPopTipView.alloc.initWithTitle("SRM:", message:"")
      @srm_indicator.delegate = nil
      @srm_indicator.disableTapToDismiss = true
      @srm_indicator.dismissTapAnywhere = false
      @srm_indicator.titleAlignment = UITextAlignmentCenter
      @srm_indicator.textAlignment = UITextAlignmentCenter

      @transient_view = add UIView.new
    end

    if srm > total_steps / 2
      text_color = UIColor.whiteColor
    else
      text_color = UIColor.blackColor
    end

    set_attributes @srm_indicator, {
      message: srm_string,
      backgroundColor: SRM.color(srm),
      textColor: text_color,
      titleColor: text_color
    }

    @transient_view.frame = CGRectMake(cgpoint.x, cgpoint.y, 1, 1)

    @srm_indicator.presentPointingAtView(@transient_view, inView:view, animated:false)
  end

  def willRotateToInterfaceOrientation(orientation, duration:duration)
    self.will_rotate(orientation, duration)

    if [UIInterfaceOrientationPortrait, UIInterfaceOrientationPortraitUpsideDown].include? orientation
      orientation = :portrait
    else
      orientation = :landscape_left
    end

    @gradient.frame = CGRectMake(0, 0, Device.screen.width_for_orientation(orientation), Device.screen.height_for_orientation(orientation) - 44)

  end

end
