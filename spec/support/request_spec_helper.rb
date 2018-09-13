module Request
  module JsonHelpers
    # Parse JSON response to ruby hash
    def json_response
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end

  # Our headers helpers module
  module HeadersHelpers
    def headers
      { 
        CONTENT_TYPE: 'application/json; charset=utf-8',
        ACCEPT: 'application/json'
      }
    end

    def api_header(version = 1)
      request.headers['Accept'] = "application/vnd.marketplace.v#{version}"
    end

    def api_response_format(format = Mime::JSON)
      request.headers['Accept'] = "#{request.headers['Accept']},#{format}"
      request.headers['Content-Type'] = format.to_s
    end

    def include_default_accept_headers
      api_header
      api_response_format
    end
  end
end