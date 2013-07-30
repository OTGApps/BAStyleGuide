describe "MainScreen functionality" do
  tests MainScreen

  # Override controller to properly instantiate
  def controller
    rotate_device to: :portrait, button: :bottom
    @screen ||= MainScreen.new(nav_bar: true)
    @screen.will_appear
    @screen.navigation_controller
  end

  after do
    @screen = nil
  end

  it "should have a navigation bar" do
    wait 0.5 do
      @screen.navigationController.should.be.kind_of(UINavigationController)
    end
  end

  it "should have lots of sections" do
    wait 0.5 do
    	@screen.table_data.count.should > 10
    end
  end

  it "should have Styles as cell data" do
    wait 0.5 do
    	@screen.table_data[5][:cells].each do |cell|
    		cell[:arguments][:style].class.should == Style
    	end
    end
	end

  it "should select all cells and go back" do
    wait 0.5 do

      ips = []


      (1..@screen.table_view.numberOfSections-1).to_a.each do |section| # (skip the first section)
        rows = @screen.table_view.numberOfRowsInSection(section)
        (0..rows-1).to_a.each do |row|
          ips << NSIndexPath.indexPathForRow(row, inSection:section)
        end
      end

      ips.each do |ip|
        wait 0.75 do
          @screen.table_view.scrollToRowAtIndexPath(ip, atScrollPosition:UITableViewScrollPositionMiddle, animated:false)

          # wait 1.5 do
          #   # puts "#{section}, #{row} (#{indexPath})"
          #   tap(@screen.table_view.cellForRowAtIndexPath(indexPath))

          #   wait 0.75 do
          #     tap("Back")
          #   end
          # end
        end
      end

    end
  end
end
