class FlavorWheelScreen < PM::Screen

  title "Flavor Wheel"

  def will_appear
    @rotation_deg = 0
    @view_loaded ||= begin

      view.backgroundColor = UIColor.whiteColor

      @wheel = add UIImageView.alloc.initWithImage(UIImage.imageNamed("flavor_wheel.png")), {
        frame: CGRectMake(10, 10, view.frame.size.height * 1.75, view.frame.size.height * 1.75),
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
