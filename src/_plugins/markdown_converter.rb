require_relative '../_shared/_plugins/markdown_with_code_excerpts'

module Jekyll
  module Converters

    # Kramdown plugin extension that runs MarkdownWithCodeExcerpts and
    # CodeExcerptProcessor, which removes <?code-excerpt ?> tags before
    # Kramdown.
    class DartSiteMarkdown < Converter
      priority :high

      include MarkdownWithCodeExcerptsConverterMixin

      def initialize(config = {})
        super(config)
        @cec = MarkdownWithCodeExcerpts.new(config)
      end

      def convert(content)
        @cec.convert(content)
      end
    end
  end
end
