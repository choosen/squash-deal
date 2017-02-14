module Requests
  # help parse json in specs
  module JsonHelpers
    def json
      @json ||= JSON.parse(response.body)
    end
  end
end
