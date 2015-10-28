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
    return "" if self.send(property).nil? || self.send(property) == ""

    title = "<h2>#{property_title(property)}</h2>"
    title << "<p>#{self.send(property)}</p>"
    title
  end

  def specs_html
    table = "<h2>" + I18n.t(:statistics) + "</h2>"
    li = ""
    table << "<ul>"
    %w(og fg ibu srm ebc abv abw).each do |spec|
      plato = ""
      if PROPERTIES.member? "#{spec}_plato".to_sym
        plato_score = self.send(spec + '_plato')
        plato = " (#{plato_score} plato)" if plato_score.chomp != ""
      end

      li << "<li>" + spec.upcase + ": " + self.send(spec) + "#{plato}</li>" unless self.send(spec).empty?
    end
    return li if li == ""

    table = "<h2>" + I18n.t(:statistics) + "</h2>"
    table << "<ul>"
    table << li
    table << "</ul>"
    table
  end

  def property_title(property)
    case property
    when :appearance, :aroma, :comments, :ingredients, :mouthfeel, :flavor, :history
      I18n.t(property)
    when :impression
      I18n.t(:impression)
    when :examples
      I18n.t(:examples)
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
    return nil if self.srm.nil? || self.srm.downcase == "n/a"
    self.srm.split(/\ ?-\ ?/) # gets 2-4 or 2 - 4
  end

end
