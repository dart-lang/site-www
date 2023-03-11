module NameBreaker
  def name_breaker(breaking_string)
    return breaking_string.gsub('_', '_<wbr />')
  end
end

Liquid::Template.register_filter(NameBreaker)
