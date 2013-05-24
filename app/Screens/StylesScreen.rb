class StylesScreen < ProMotion::SectionedTableScreen
  title "Back"
  searchable :placeholder => "Search Styles"

  def will_appear
    self.setTitle("Brewers Association", subtitle:"2013 Style Guides")

    set_attributes self.view, {
      backgroundColor: UIColor.whiteColor
    }

    set_nav_bar_right_button UIImage.imageNamed("info.png"), action: :open_info_screen
  end

  def table_data
  	@table_setup ||= begin
      s = []

      s << introduction_section
      s << judging_tools_section

      sections.each do |section|
    		s << {
    			title: section.format_title,
    			cells: build_cells(section)
    		}
    	end

      s << bibliography_section
    end
  end

  def build_cells(path)
      c = []
    	category_listing(path).each do |style|
        c << {
    			title: style.format_title,
          cell_identifier: "StyleCell",
    			action: :open_style,
    			arguments: {:path => File.join(guidelines_path, path, style), :name => style.format_title}
    		}
    	end
  	 c
  end

  def judging_tools_section
    {
      title: "Judging Tools",
      cells:
      [{
        title: "Flavor Wheel",
        cell_identifier: "ImagedCell",
        image: { image: UIImage.imageNamed("flavor_wheel_thumb.png") },
        action: :open_flavor_wheel
      }]
    }
  end

  def introduction_section
    {
      title: nil,
      cells:
      [{
        title: "Introduction",
        cell_identifier: "ImagedCell",
        image: { image: UIImage.imageNamed("ba_logo_thumb.png") },
        action: :open_style,
        arguments: {
          :path => File.join(guidelines_path, "Introduction.html"),
          :name => "Introduction"
        }
      }]
    }
  end

  def bibliography_section
    {
      title: "Extras",
      cells:
      [{
        title: "Bibliography",
        cell_identifier: "StyleCell",
        action: :open_style,
        arguments: {
          :path => File.join(guidelines_path, "Bibliography of Resources.html"),
          :name => "Bibliography"
        }
      }]
    }
  end

  def open_style(args={})
  	open DetailScreen.new(args)
  end

  def open_info_screen(args={})
    open DetailScreen.new(:path => File.join(guidelines_path, "Info.html"), :name => "About")
  end

  def open_flavor_wheel(args={})
    ap "Opening flavor wheel screen"
    open FlavorWheelScreen.new
  end

  def open_srm(args={})
    ap "Opening srm screen"
  end

  def sections
  	Dir.entries(guidelines_path).select{|d|
      File.directory?(File.join(guidelines_path, d)) and not_dotfile(d)
  	}
  end

  def guidelines_path
  	File.join(App.resources_path, "Guidelines")
	end

  def category_path(category)
  	File.join(guidelines_path, category)
	end

	def category_listing(cateogry)
		cp = category_path(cateogry)
		Dir.entries(cp).select{|d|
  		!File.directory?(File.join(cp, d)) and not_dotfile(d)
  	}
	end

  def not_dotfile(d)
    !(d =='.' || d == '..' || d[0] == '.')
  end

end
