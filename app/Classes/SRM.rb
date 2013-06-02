class SRM

	# Colors extracted from http://methodbrewery.com/srm.php
	@@matrix = {
		"1"   => [250, 250, 160],
		"2"   => [250, 250, 105],
		"3"   => [245, 246, 50],
		"4"   => [235, 228, 47],
		"5"   => [225, 208, 50],
		"6"   => [215, 188, 52],
		"7"   => [205, 168, 55],
		"8"   => [198, 148, 56],
		"9"   => [193, 136, 56],
		"10"   => [192, 129, 56],
		"11"   => [192, 121, 56],
		"12"   => [192, 114, 56],
		"13"   => [190, 106, 56],
		"14"   => [180, 99, 56],
		"15"   => [167, 91, 54],
		"16"   => [152, 84, 51],
		"17"   => [138, 75, 48],
		"18"   => [124, 68, 41],
		"19"   => [109, 60, 34],
		"20"   => [95, 53, 23],
		"21"   => [81, 45, 11],
		"22"   => [67, 38, 12],
		"23"   => [52, 30, 17],
		"24"   => [38, 23, 22],
		"25"   => [33, 19, 18],
		"26"   => [28, 16, 15],
		"27"   => [23, 13, 12],
		"28"   => [18, 9, 8],
		"29"   => [13, 6, 5],
		"30"   => [8, 3, 2]
	}

	def self.color(value)
		BubbleWrap.rgb_color(@@matrix[value.to_s][0], @@matrix[value.to_s][1], @@matrix[value.to_s][2])
	end

	def self.cgcolor(value)
		c = SRM.color(value)
		c.CGColor
	end

	def self.imageWithSRM(value, andSize:size)
		# size expects a CGSize
    color = SRM.color(value)

    rect = CGRectMake(0.0, 0.0, size.width, size.height)
    UIGraphicsBeginImageContext(rect.size)
    context = UIGraphicsGetCurrentContext()

    CGContextSetFillColorWithColor(context, color.CGColor)
    CGContextFillRect(context, rect)

    image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    image
	end

	def self.steps
		@@matrix
	end

	def self.spectrum
		colors = []
		@@matrix.each do |key, value|
			colors << BubbleWrap.rgb_color(value[0], value[1], value[2].to_f).CGColor
		end
		colors
	end

	def self.closest_srm_to_color(compare_color)
		components = CGColorGetComponents(compare_color.CGColor)
		ap components.inspect
		c = components[0]
		ap c
		NSLog("Red: %f", components[0])
		NSLog("Green: %f", components[1])
		NSLog("Blue: %f", components[2])
		NSLog("Alpha: %f", CGColorGetAlpha(compare_color.CGColor))
	end




end
