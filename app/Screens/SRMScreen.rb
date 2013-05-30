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

      view.when_panned do |thing|
        ap thing
      end

    end
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
