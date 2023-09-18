module Jekyll
  class DiagnosticPageGenerator < Jekyll::Generator
    def generate(site)
      linter_rules = site.data['linter_rules']

      linter_rules.each { |lint|
        site.pages << LinterPage.new(site, lint)
      }
    end
  end

  class LinterPage < Jekyll::PageWithoutAFile
      def initialize(site, lint)
        @site = site
        @base = site.source
        @dir  = "/tools/linter-rules"
        @basename = lint['name']
        @ext = '.md'
        @name = "#{lint['name']}.md"
        @content = ""

        @data = {
          'title' => basename,
          'description' => "#{basename} linter rule documentation.",
          'layout' => 'linter-rule-standalone',
          'lint' => lint,
          'underscore_breaker_titles' => true,
          'body_class' => 'generated-page',
          'show_breadcrumbs' => true
        }

      end
    end
end
