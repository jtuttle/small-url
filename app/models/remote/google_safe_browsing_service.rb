module Remote
  class GoogleSafeBrowsingService
    def is_safe?(url)
      response = RestClient.post(lookup_api_url, payload(url), headers)
      response.code == 200 && JSON.parse(response.body).empty?
    rescue
      # This prevents Safe Browsing API hiccups from disabling Small URL.
      true
    end

    private
    
    def lookup_api_url
      "https://safebrowsing.googleapis.com/v4/threatMatches:find?key=#{api_key}"
    end

    def api_key
      ENV['GOOGLE_SAFE_BROWSING_API_KEY']
    end
    
    def payload(url)
      {
        "client" => {
          "clientId" => "small_url",
          "clientVersion" => "1.0.0"
        },
        "threatInfo" => {
          "threatTypes" => threat_types,
          "platformTypes" => ["ANY_PLATFORM"],
          "threatEntryTypes" => ["URL"],
          "threatEntries" => [
            { "url" => url }
          ]
        }
      }.to_json
    end

    def threat_types
      ["THREAT_TYPE_UNSPECIFIED", "MALWARE", "SOCIAL_ENGINEERING",
       "UNWANTED_SOFTWARE", "POTENTIALLY_HARMFUL_APPLICATION"]
    end

    def headers
      { "content-type" => "application/json" }
    end
  end
end
