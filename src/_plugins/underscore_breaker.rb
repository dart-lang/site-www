module UnderscoreBreaker
  # Adds `<wbr>` after underscores to allow the browser
  # to more intelligently wrap identifiers and text split with underscores.
  # If `in_anchor` is `true`, it will only replace the inner text content.
  def underscore_breaker(string_to_break, in_achor = false)
    return unless string_to_break.include? '_'
    if in_achor then
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
