class AppDelegate < ProMotion::Delegate

  tint_color "#933C06".to_color

  attr_accessor :main_screen

  def on_load(app, options)

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

    self.main_screen = MainScreen.new(nav_bar: true)

    if Device.ipad?
      open_split_screen main_screen, DetailScreen.new(nav_bar: true), title: "2013 BA Styles".__
    else
      open main_screen
    end
  end

  #Flurry exception handler
  def uncaughtExceptionHandler(exception)
    Flurry.logError("Uncaught", message:"Crash!", exception:exception)
  end

  def will_enter_foreground
    Appirater.appEnteredForeground true unless Device.simulator?
  end

end
