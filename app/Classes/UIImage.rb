class UIImage

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
