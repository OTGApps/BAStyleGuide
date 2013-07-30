# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'
require 'bundler'

Bundler.setup
Bundler.require

Motion::Project::App.setup do |app|
  app.name = 'BA Styles'
  app.deployment_target = "5.0"
  app.device_family = [:iphone, :ipad]
  app.interface_orientations = [:portrait, :landscape_left, :landscape_right, :portrait_upside_down]
  app.identifier = 'com.mohawkapps.BAStyles'
  app.version = "1"
  app.short_version = "1.0.0"
  app.frameworks += ["/usr/lib/libsqlite3.dylib", "QuartzCore"]
  app.prerendered_icon = true
  app.info_plist['APP_STORE_ID'] = 670470983

  app.files_dependencies 'app/Screens/DetailScreen.rb' => 'app/Screens/SizeableWebScreen.rb'
  app.files_dependencies 'app/Screens/IntroScreen.rb'  => 'app/Screens/SizeableWebScreen.rb'

  app.files_dependencies 'app/Screens/DetailScreen.rb' => 'app/Screens/SizeableWebScreen.rb'
  app.files_dependencies 'app/Screens/IntroScreen.rb'  => 'app/Screens/SizeableWebScreen.rb'

  app.pods do
    pod 'FlurrySDK'
    pod 'Appirater'
    pod 'Harpy'
    pod 'SwipeView'
    pod 'OpenInChrome'
    pod 'SwipeView'
    pod 'OpenInChrome'
    pod 'SVProgressHUD'
  end

  app.vendor_project('vendor/ContainerSubscriptAccess', :static, :cflags => '-fobjc-arc')

  app.development do
    app.entitlements['get-task-allow'] = true
    app.codesign_certificate = "iPhone Developer: Mark Rickert (YA2VZGDX4S)"
    app.provisioning_profile = "./provisioning/development.mobileprovision"
  end

  app.release do
    app.entitlements['get-task-allow'] = false
    app.codesign_certificate = "iPhone Distribution: Mohawk Apps, LLC (DW9QQZR4ZL)"
    app.provisioning_profile = "./provisioning/release.mobileprovision"
  end

end
