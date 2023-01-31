module UnderscoreBreaker
  def underscore_breaker(string_to_break, in_achor = false)
    return unless string_to_break.include? '_'
    if in_achor then
      return string_to_break.gsub(/>([a-zA-Z_]*?)</) do |match|
        ">#{$1.gsub('_', '_<wbr>')}<"
      end
    end

    return string_to_break.gsub('_', '_<wbr>')
  end
end

Liquid::Template.register_filter(UnderscoreBreaker)
