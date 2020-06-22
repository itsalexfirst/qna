module LinksHelper
  require 'open-uri'

  def gist_content(resource)
    gist("#{resource.url}.json")['div']
  end

  def gist(url)
    JSON.load(open(url))
  end
end
