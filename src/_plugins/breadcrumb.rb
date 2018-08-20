# Used with permission. Based on code posted at
# biosphere.cc/software-engineering/jekyll-breadcrumbs-navigation-plugin/.

module Jekyll

  ##
  # Monkey patch Jekyll's Page class
  class Page

    ##
    # We add a custom method to the page variable, that returns an ordered list of its
    # parent pages ready for iteration.
    def ancestors
      # STDERR.puts "---------"
      a = []
      url = self.url
      # STDERR.puts "Page is #{url.inspect}"
      if url.split(".")[-1] == "html" # ignore .css, .js, ...
        while url != "/index.html"
          pt = url.split("/")
          if pt.length <= 2 then
            url = "/index.html"
          else
            if pt[-1] != "index.html" then
              # go to directory index
              pt[-1] = "index.html"
              url = pt.join("/")
            else
              # one level up
              url = pt[0..-3].join("/") + "/index.html"
            end

            # skip homepage
            if url != "/index.html" then
              potential_page = get_page_from_url(url)

              # skip missing index.html pages
              if defined? potential_page.name then
                a << potential_page
              end
            end
          end
        end

        if a != nil then
          return a.reverse
        else
          return nil
        end
      end
    end

    ##
    # Make ancestors available in liquid
    alias orig_to_liquid to_liquid
    def to_liquid
      h = orig_to_liquid
      h['ancestors'] = self.ancestors
      return h
    end

    private

    ##
    # Gets Page object that has given url. Very efficient O(n) solution.
    def get_page_from_url(url)
      site.pages.each do |page|
        if page.url == url then
          return page
        end
      end
    end
  end
end