json.urls @urls do |url|
  json.original_url Logical::UrlEncryptor.new(url.salt).decrypt(url.original_url)
  json.small_url "#{request.base_url}/#{Logical::UrlTokenEncoder.new.encode(url.id.to_s)}"
  json.visit_count url.visit_count
  json.disabled url.disabled
  json.public_identifier url.public_identifier
end
