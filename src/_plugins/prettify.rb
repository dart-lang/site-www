# Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

require 'cgi'

module Prettify

  # Wraps code with tags for Prettify.
  #
  # Example usage:
  #
  # {% prettify dart %}
  # // dart code here
  # {% endprettify %}
  #
  # The language name can be ommitted if it is not known.
  # Use 'nocode' or 'none' as the language to turn of prettifying.

  class Tag < Liquid::Block

    Syntax = /\s*(\w+)\s*/o

    def initialize(tag_name, markup, tokens)
      super
      @lang = $1 if markup =~ Syntax
    end

    def render(context)
      out = '<pre class="'
      unless @lang == 'nocode' || @lang == 'none'
        out += 'prettyprint'
        out += ' lang-' + @lang if @lang
      end
      out += '">'

      # Strip excess whitespace at the end (which will be present if the code is indented)
      contents = super.gsub /(\s*\n\s*)+\z/, ''
      contents = CGI::escapeHTML(contents)

      contents.gsub!('[[strike]]', '<code class="nocode strike">')
      contents.gsub!('[[/strike]]', '</code>')

      contents.gsub!('[[highlight]]', '<code class="nocode highlight">')
      contents.gsub!('[[/highlight]]', '</code>')

      contents.gsub!('[!', '<span class="highlight">')
      contents.gsub!('!]', '</span>')

      contents.gsub!('[[note]]', '<code class="nocode note">')
      contents.gsub!('[[/note]]', '</code>')

      contents.gsub!('[[red]]', '<code class="nocode red">')
      contents.gsub!('[[/red]]', '</code>')

      out += contents + "</pre>"
    end

  end
end

Liquid::Template.register_tag('prettify', Prettify::Tag)
