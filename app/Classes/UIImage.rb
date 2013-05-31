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

end
