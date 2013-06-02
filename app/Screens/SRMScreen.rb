class SRMScreen < PM::Screen

  title "SRM Spectrum"

  def will_appear
    @view_loaded ||= begin
      # view.setBackgroundColor UIColor.redColor
      @top_view_height = 44

      @srm_views ||= []
      height = self.view.frame.size.height - @top_view_height

      @gradient_view = add UIView.new, {
        left: 0,
        top: @top_view_height,
        width: self.view.frame.size.width,
        height: height,
      }
      @gradient_view.setBackgroundColor UIColor.whiteColor

      @gradient = CAGradientLayer.layer
      @gradient.frame = view.bounds
      @gradient.colors = SRM.spectrum

      @gradient_view.layer.insertSublayer(@gradient, atIndex:0)

      @gradient_view.when_panned do |gesture|
        got_touch_point gesture.locationInView(@gradient_view)
      end

      # Add a top view that changes color.
      @top_view = add UIView.new, {
        left: 0,
        top: 0,
        width: view.frame.size.width,
        height: @top_view_height,
        background_color: UIColor.whiteColor
      }
      @top_view_label = add UILabel.new, {
        frame: @top_view.frame,
        text: "Touch Me!",
        font: UIFont.boldSystemFontOfSize(UIFont.systemFontSize),
        textAlignment: UITextAlignmentCenter,
        background_color: UIColor.clearColor
      }

    end
  end

  def got_touch_point(cgpoint)
    total_height = Device.screen.height_for_orientation(Device.orientation) - 44
    total_steps = SRM.steps.count + 1
    step_height = total_height / total_steps

    srm = (cgpoint.y / step_height).to_i + 1

    return if srm < 1

    srm_string = "     #{srm.to_s}     "

    @indicators_initialized ||= begin

      #Hide the "touch me" label
      @top_view_label.hidden = true

      @srm_indicator = set_attributes CMPopTipView.alloc.initWithTitle("SRM:", message:""), {
        delegate: nil,
        disableTapToDismiss: true,
        dismissTapAnywhere: false,
        titleAlignment: UITextAlignmentCenter,
        textAlignment: UITextAlignmentCenter,
        preferredPointDirection: PointDirectionDown,
      }

      @target_tap_view = add UIView.new
    end

    if srm > total_steps / 2
      text_border_color = UIColor.whiteColor
    else
      text_border_color = UIColor.blackColor
    end

    set_attributes @srm_indicator, {
      message: srm_string,
      backgroundColor: SRM.color(srm),
      textColor: text_border_color,
      titleColor: text_border_color,
      borderColor: text_border_color
    }

    @target_tap_view.frame = CGRectMake(cgpoint.x, cgpoint.y + @top_view_height, 1, 1)

    @srm_indicator.presentPointingAtView(@target_tap_view, inView:view, animated:false)
    @top_view.backgroundColor = SRM.color(srm)
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
