class Style

  PROPERTIES = [:id, :category, :name, :description, :og, :og_plato, :fg, :fg_plato, :abv, :abw, :ibu, :srm, :ebc]
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

  def html(property)
    ap property
    return specs_html if property == :specs
    return "" unless respond_to? "#{property.to_s}="

    text = "";
    self.send(property).split("\r").compact.each do |p|
      text << "<p>#{p}</p>"
    end
    ap text
    text
  end

  def specs_html
    table = "<h2>Vital Statistics</h2>"
    %w(og fg ibu srm abv).each do |spec|
      table << "<li>" + spec.upcase + ": " + self.send(spec) + "</li>"
    end
    table
  end

  def property_title(property)
    case property
    when :appearance, :aroma, :comments, :ingredients, :mouthfeel, :flavor, :history
      property.to_s.titlecase
    when :impression
      "Overall Impression"
    when :examples
      "Commercial Examples"
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
    return nil if self.srm.nil? || self.srm.downcase == "n/a" || self.srm.downcase.include?("varies")
    srm = self.srm
    if self.srm.include? "+"
      srm = "#{srm.chomp('+')}-#{srm.chomp('+')}"
    end
    srm.split("-")
  end

end
