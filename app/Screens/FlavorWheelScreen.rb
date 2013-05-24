class FlavorWheelScreen < PM::Screen

  title "Flavor Wheel"

  def will_appear
    @rotation_deg = 0
    @view_loaded ||= begin

      view.backgroundColor = UIColor.whiteColor

      @wheel = add CircularUIImageView.alloc.initWithImage(UIImage.imageNamed("flavor_wheel.png")), {
        frame: CGRectMake(10, 10, view.frame.size.height * 1.75, view.frame.size.height * 1.75),
        content_mode: UIViewContentModeScaleAspectFit,
        userInteractionEnabled: true,
        continueSpinning: false
      }

    end
  end

end
