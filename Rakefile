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
  app.device_family = [:iphone]
  app.identifier = "com.mohawkapps.BAStyleGuide"
  app.version = "4"
  app.short_version = "0.0.4"

  app.pods do
  	pod 'FlurrySDK'
    pod 'TestFlightSDK'
    pod 'CMPopTipView', :podspec => 'vendor/specs/CMPopTip.podspec'
end

  app.vendor_project('vendor/KTOneFingerRotationGestureRecognizer', :static, :cflags => '-fobjc-arc')

  app.development do
    app.entitlements['get-task-allow'] = true
    app.codesign_certificate = "iPhone Developer: Mark Rickert (YA2VZGDX4S)"
    app.provisioning_profile = "./provisioning/BAStyleGuideDevelopment.mobileprovision"
  end

  app.testflight do
    app.entitlements['get-task-allow'] = false
    app.codesign_certificate = "iPhone Distribution: Mohawk Apps, LLC (DW9QQZR4ZL)"
    app.provisioning_profile = "./provisioning/BAStyleGuideAdhoc.mobileprovision"
  end

  app.release do
    app.entitlements['get-task-allow'] = false
    app.codesign_certificate = "iPhone Distribution: Mohawk Apps, LLC (DW9QQZR4ZL)"
    app.provisioning_profile = "./provisioning/BAStyleGuideDistribution.mobileprovision"
  end

  app.testflight.api_token = ENV['testflight_api_token'] || abort("You need to set your Testflight API Token environment variable.")
  app.testflight.team_token = '566af85ab4aaa64ecedbd95cf7bc2bf7_MjI3Nzc2MjAxMy0wNS0yMyAyMzo0NTowNS4xNzkxODI'

end

#Rake Tasks
desc "Compile the guidelines from slim->html"
task :compile do
  puts "Compiling resources..."
  puts

  # Removing previously compiled guildelines directory
  `rm -rf ./resources/Guidelines`

  # Convert the slim documents to HTML and place in the resources directory
  Dir["./Guidelines/**/*.slim"].each do |file|
    puts "Converting #{file}"
    dst = File.join("./resources", file.chomp(".slim"))
    converted = `slimrb "#{file}"`
    FileUtils.mkdir_p(File.dirname(dst))
    File.open(dst, 'w') { |file| file.write(converted) }
  end

  `rake`
end
