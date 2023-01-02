# frozen_string_literal: true

module Requests
  module JsonHelpers
    def json
      @json ||= JSON.parse(subject.body)
    end
  end
end
