# frozen_string_literal: true

module Ryquest
  # Hold / handle writable configuration variables
  # @attr content_type [Symbol] Must be :form or :json.
  #   Define in which format response! send data. Accepted value:
  #   * :form (default) - x-www-form-urlencoded
  #   * :json - JSON
  #   Note that the value will affect CONTENT-TYPE header
  class Configuration
    attr_reader :content_type

    def content_type= value
      raise ArgumentError, 'content_type configuration value must be form or json' if %i[form json].exclude? value

      @content_type = value
    end

    # Define default configuration value
    def initialize
      @content_type = :form
    end
  end
end
