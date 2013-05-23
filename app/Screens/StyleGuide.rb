class StyleGuide < ProMotion::SectionedTableScreen
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

      # Intro esction
      s << {
        title: nil,
        cells: {
          [{
            title: "Introduction",
            action: :open_style,
            arguments: {:path => File.join(guidelines_path, "introduction.html"), :name => "Introduction"}
            }]
        }
      }

      sections.each do |section|
    		s << {
    			title: section.format_title,
    			cells: build_cells(section)
    		}
    	end
    	s
    end
  end

  def build_cells(path)
      c = []
    	category_listing(path).each do |style|
    		ap style
        c << {
    			title: style.format_title,
    			action: :open_style,
    			arguments: {:path => File.join(guidelines_path, path, style), :name => style.format_title}
    		}
    	end
  	 c
  end

  def open_style(args={})
  	open Detail.new(args)
  end

  def open_info_screen(args={})
    ap args
    ap "Opening info screen"
  end

  def open_srm(args={})
    ap "Opening srm screen"
  end

  def sections
  	Dir.entries(guidelines_path).select{|d|
  		ap File.join(guidelines_path, d)
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
