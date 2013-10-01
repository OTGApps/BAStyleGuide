class Style

  PROPERTIES = [:id, :category, :name, :transname, :description, :og, :og_plato, :fg, :fg_plato, :abv, :abw, :ibu, :srm, :ebc]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }

  def initialize(args={})
    args.each { |key, value|
      if PROPERTIES.member? key.to_sym
        self.send("#{key}=", value)
      end
    }
  end

  def title
    self.name
  end

  def subtitle
    self.transname
  end

  def html(property)
    return specs_html if property == :specs
    return "" unless respond_to? "#{property.to_s}="

    text = "<h2>#{property_title(property)}</h2>"
    self.send(property).split("\r").compact.each do |p|
      text << "<p>#{p}</p>"
    end
    text
  end

  def specs_html
    specs = ""
    %w(og fg ibu srm ebc abv abw).each do |spec|
      plato = ""
      if PROPERTIES.member? "#{spec}_plato".to_sym
        plato_score = self.send(spec + '_plato')
        plato = " (#{plato_score} plato)" if plato_score.chomp != ""
      end

      specs << "<li>" + spec.upcase + ": " + self.send(spec) + "#{plato}</li>" unless self.send(spec).empty?
    end
    return specs if specs == ""

    table = "<h2>" + "Vital Statistics".__ + "</h2>"
    table << "<ul>"
    table << specs
    table << "</ul>"
    table
  end

  def property_title(property)
    case property
    when :appearance, :aroma, :comments, :ingredients, :mouthfeel, :flavor, :history
      property.to_s.titlecase.__
    when :impression
      "Overall Impression".__
    when :examples
      "Commercial Examples".__
    end
  end

  def search_text
    search = ""
    %w(description).each do |prop|
      search << (" " + self.send(prop)) unless self.send(prop).nil? || self.send(prop).downcase == "n/a"
    end
    search.split(/\W+/).uniq.join(" ")
  end

  def srm_range
    return nil if self.srm.nil? || self.srm.downcase == "n/a" || self.srm.downcase.include?("varies") || !self.srm[0,1].numeric?

    srm = self.srm
    if self.srm.include? "+"
      srm = "#{srm.chomp('+')}-#{srm.chomp('+')}"
    end
    srm.split("-")
  end

end
