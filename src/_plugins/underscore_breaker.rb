module UnderscoreBreaker
  def underscore_breaker(string_to_break)
    return string_to_break.gsub('_', '_<wbr>')
  end
end

Liquid::Template.register_filter(UnderscoreBreaker)
