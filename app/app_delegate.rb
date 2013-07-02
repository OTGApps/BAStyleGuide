class AppDelegate < ProMotion::Delegate

  attr_accessor :jump_to_style

  def on_load(app, options)

    if defined? TestFlight
      TestFlight.setDeviceIdentifier UIDevice.currentDevice.uniqueIdentifier
      TestFlight.takeOff "e9a2e874-1b13-426c-ad0f-6958e7b2889c"
    end

    # 3rd Party integrations
    unless Device.simulator?
      app_id = NSBundle.mainBundle.objectForInfoDictionaryKey('APP_STORE_ID')

      # Flurry
      NSSetUncaughtExceptionHandler("uncaughtExceptionHandler")
      Flurry.startSession("2C4JRB6VQR6FYS54NFRC")

      # Appirater
      Appirater.setAppId app_id
      Appirater.setDaysUntilPrompt 5
      Appirater.setUsesUntilPrompt 10
      Appirater.setTimeBeforeReminding 5
      Appirater.appLaunched true

      # Harpy
      Harpy.sharedInstance.setAppID app_id
      Harpy.sharedInstance.checkVersion
    end

    # Set initial font size (%)
    App::Persistence['font_size'] = 100 if App::Persistence['font_size'].nil?

    main_screen = MainScreen.new(nav_bar: true)

    if Device.ipad?
      open_split_screen main_screen, DetailScreen.new(nav_bar: true), title: "Split Screen Title"
    else
      open main_screen
    end
  end

  #Flurry exception handler
  def uncaughtExceptionHandler(exception)
    Flurry.logError("Uncaught", message:"Crash!", exception:exception)
  end

  def applicationWillEnterForeground(application)
    Appirater.appEnteredForeground true unless Device.simulator?
  end

end
