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
  app.version = "5"
  app.short_version = "0.1.0"
  app.frameworks += %w(AVFoundation CoreVideo CoreMedia ImageIO QuartzCore)

  app.pods do
  	pod 'FlurrySDK'
    pod 'TestFlightSDK'
    pod 'CMPopTipView', :podspec => 'vendor/specs/CMPopTip.podspec'
  end

  # Vendor Projects - ARC
  %w(KTOneFingerRotationGestureRecognizer CKImageAdditions).each do |v|
    app.vendor_project("vendor/#{v}", :static, :cflags => '-fobjc-arc')
  end
  # Vendor Projects - non-ARC
  %w(CaptureSessionManager UIColor-Utilities).each do |v|
    app.vendor_project("vendor/#{v}", :static)
  end

  app.development do
    app.entitlements['get-task-allow'] = true
    app.codesign_certificate = "iPhone Developer: Mark Rickert (YA2VZGDX4S)"
    app.provisioning_profile = "./provisioning/development.mobileprovision"
  end

  app.testflight do
    app.entitlements['get-task-allow'] = false
    app.codesign_certificate = "iPhone Distribution: Mohawk Apps, LLC (DW9QQZR4ZL)"
    app.provisioning_profile = "./provisioning/adhoc.mobileprovision"
  end

  app.release do
    app.entitlements['get-task-allow'] = false
    app.codesign_certificate = "iPhone Distribution: Mohawk Apps, LLC (DW9QQZR4ZL)"
    app.provisioning_profile = "./provisioning/release.mobileprovision"
  end

  app.testflight.api_token = ENV['testflight_api_token'] || abort("You need to set your Testflight API Token environment variable.")
  app.testflight.team_token = '566af85ab4aaa64ecedbd95cf7bc2bf7_MjI3Nzc2MjAxMy0wNS0yMyAyMzo0NTowNS4xNzkxODI'

end

#Rake Tasks
namespace :compile do

  desc "Compile the Brewers Association Version"
  task :ba => :reset_everything do
    copy_resources("BrewersAssociation")
    copy_provisioning("BrewersAssociation")
    compile_guidelines('BrewersAssociation')

    `rake clean && rake`
  end

  desc "Compile the BJCP Version"
  task :bjcp => :reset_everything do
    copy_resources("BJCP")
    copy_provisioning("BJCP")
    compile_guidelines('BJCP')

    `rake clean && rake`
  end

  desc "Reset folders and copy shared assets"
  task :reset_everything do
    reset_folder("./resources/.")
    reset_folder("./provisioning/.")
    copy_resources("shared")
  end
end

def reset_folder(name)
  FileUtils.rm_rf name, secure: true
end

def reset_resources_folder
  reset_folder "./resources/."
end

def reset_resources_folder
  reset_folder "./resources/."
end

def copy_resources(directory)
  FileUtils.cp_r Dir.glob("./version/#{directory}/resources/**"), "./resources/"
end

def copy_provisioning(directory)
  FileUtils.mkdir_p("./provisioning/") # Create the directory if it doesn't exist.
  FileUtils.cp Dir.glob("./version/#{directory}/provisioning/**"), "./provisioning/"
end

def compile_guidelines(directory)
  Dir["./version/#{directory}/guidelines/**/*.slim"].each do |file|
    puts "Converting #{file}"
    dst = File.join("./resources", file.chomp('.slim').gsub("./version/#{directory}/", ""))
    converted = `slimrb "#{file}"`
    FileUtils.mkdir_p(File.dirname(dst))
    File.open(dst, 'w') { |file| file.write(converted) }
  end
end
