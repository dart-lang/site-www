module UnderscoreBreaker
  # Adds `<wbr>` after underscores to allow the browser
  # to more intelligently wrap identifiers and text split with underscores.
  # If `in_anchor` is `true`, it will only replace the inner text content.
  def underscore_breaker(string_to_break, in_anchor = false)
    # Only consider text which has underscores in it to keep this simpler
    return string_to_break unless string_to_break.include? '_'
    if in_anchor then
      # If the replacement is to be done inside an anchor,
      # we don't want to replace the href,
      # just the inner text content.
      return string_to_break.gsub(/>([a-zA-Z_]*?)</) do |match|
        ">#{$1.gsub('_', '_<wbr>')}<"
      end
    end

    return string_to_break.gsub('_', '_<wbr>')
  end
end

Liquid::Template.register_filter(UnderscoreBreaker)
