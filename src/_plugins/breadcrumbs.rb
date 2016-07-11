Jekyll::Hooks.register :pages, :pre_render do |page, payload|
  drop = Drops::BreadcrumbItem

  if page.url == "/"
    then payload["breadcrumbs"] = [
      drop.new(page, payload)
    ]
  else
    payload["breadcrumbs"] = []
    pth = page.url.split("/")

    0.upto(pth.size - 1) do |int|
      joined_path = pth[0..int].join("/")
      item = page.site.pages.find { |page_| joined_path == "" && page_.url == "/" || page_.url.chomp("/") == joined_path }
      payload["breadcrumbs"] << drop.new(item, payload) if item
    end
  end
end

Jekyll::Hooks.register :documents, :pre_render do |documents, payload|
  drop = Drops::BreadcrumbItem

  if documents.url == "/"
    then payload["breadcrumbs"] = [
      drop.new(documents, payload)
    ]
  else
    payload["breadcrumbs"] = []
    pth = documents.url.split("/")

    0.upto(pth.size - 1) do |int|
      joined_path = pth[0..int].join("/")
      item = documents.site.documents.find { |documents| joined_path == "" && documents.url == "/" || documents.url.chomp("/") == joined_path }
      payload["breadcrumbs"] << drop.new(item, payload) if item
    end
  end
end
