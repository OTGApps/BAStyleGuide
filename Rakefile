# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'

Bundler.setup
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'BA Styles'
  app.deployment_target = "5.0"
  app.device_family = [:iphone, :ipad]
  app.identifier = "com.mohawkapps.BAStyleGuide"
  app.version = "1"
  app.short_version = "1.0.0"

  app.pods do
  	# pod 'NUI'
  	pod 'FlurrySDK'
	end

end
