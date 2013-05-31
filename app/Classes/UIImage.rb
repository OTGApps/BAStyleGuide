class UIImage

	def average_color
    colorSpace = CGColorSpaceCreateDeviceRGB()
    rgba = []
    context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, KCGImageAlphaPremultipliedLast | KCGBitmapByteOrder32Big)

    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), self.CGImage)
    CGColorSpaceRelease(colorSpace)
    CGContextRelease(context)

    if rgba[3] > 0
      alpha = rgba[3]/255.0
      multiplier = alpha/255.0
      UIColor.colorWithRed(rgba[0].to_f * multiplier,
                     green:rgba[1].to_f * multiplier,
                      blue:rgba[2].to_f * multiplier,
                     alpha:alpha)
    else
      UIColor.colorWithRed(rgba[0] / 255.0,
                     green:rgba[1] / 255.0,
                      blue:rgba[2] / 255.0,
                     alpha:rgba[3] / 255.0)
  	end
	end

	# Crops from the top right of the image for some reason.
	# CGPoint{0, 0} is top right.
	def crop(rect)
    if self.scale > 1.0
			rect = CGRectMake(
				rect.origin.x * self.scale,
				rect.origin.y * self.scale,
				rect.size.width * self.scale,
				rect.size.height * self.scale
			)
    end

		imageRef = CGImageCreateWithImageInRect(self.CGImage, rect)
		UIImage.imageWithCGImage(imageRef, scale:self.scale, orientation:self.imageOrientation)
  end

end
