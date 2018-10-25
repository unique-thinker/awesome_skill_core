# frozen_string_literal: true

module Request
  module JsonHelpers
    # Parse JSON response to ruby hash
    def json_response
      @json_response = JSON.parse(response.body, symbolize_names: true)
    end
  end

  # Our headers helpers module
  module HeadersHelpers
    def headers
      {
        'Content-Type': 'application/json; charset=utf-8',
        Accept:         'application/json'
      }
    end

    def normalize_headers(headers)
      headers.slice('access-token', 'token-type', 'client','uid', 'expiry')
    end

    def api_header_version(version=1)
      "application/vnd.awesome-skill.v#{version}"
    end

    # return headers
    def api_headers(headers={}, format='json', version=1)
      head = {}
      head['Accept'] = "#{api_header_version(version)}+#{format}"
      head.merge!(normalize_headers(headers))
    end
  end
end
