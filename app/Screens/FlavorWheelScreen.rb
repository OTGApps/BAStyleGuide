class FlavorWheelScreen < PM::Screen

  title "Flavor Wheel"

  def will_appear
    @rotation_deg = 0
    @view_loaded ||= begin

      view.backgroundColor = UIColor.whiteColor

      wheel_size = Device.screen.height_for_orientation(:portrait) * 1.2

      @wheel = add UIImageView.alloc.initWithImage(UIImage.imageNamed("flavor_wheel.png")), {
        frame: CGRectMake(10, 10, wheel_size, wheel_size),
        content_mode: UIViewContentModeScaleAspectFit,
        userInteractionEnabled: true,
      }

      rotateGesture = KTOneFingerRotationGestureRecognizer.alloc.initWithTarget(self, action:"rotating:")
      @wheel.addGestureRecognizer(rotateGesture)

    end
  end

  def rotating(recognizer)
    view = recognizer.view
    view.setTransform(CGAffineTransformRotate(view.transform, recognizer.rotation))
  end

end
