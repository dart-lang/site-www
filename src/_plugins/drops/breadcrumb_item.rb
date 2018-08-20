module Drops
  class BreadcrumbItem < Liquid::Drop
    extend Forwardable

    def_delegator :@page, :data
    def_delegator :@page, :url

    def initialize(page, payload)
      @payload = payload
      @page = page
    end

    def title
      @page.data["breadcrumb"] || @page.data["short-title"] || @page.data["title"]
    end

    def subset
      @page.data["subset"]
    end
  end
end
