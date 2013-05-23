class AppDelegate < ProMotion::Delegate

  def on_load(app, options)
    open StyleGuide.new(nav_bar: true)
  end
end
