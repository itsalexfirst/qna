module LinksHelper
  require 'net/http'

  def gist_content(resource)
    gist_hash = get_gist("#{resource.url}.json")
    gist_hash.has_key?('div') ? gist_hash['div'] : 'N/A'
  end

  def get_gist(url)
    response = Net::HTTP.get_response(URI(url))
    data = response.body
    JSON.load(data)
    rescue StandardError
  end
end
