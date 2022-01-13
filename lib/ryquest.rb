# frozen_string_literal: true

require 'ryquest/configuration'
require 'ryquest/context'

# Root module
module Ryquest
  # @return [Ryquest::Configuration] Global configuration instance (create it if not present)
  def self.configuration; @configuration ||= Configuration.new end

  # Yields #configuration to a block
  # @yield [Ryquest::Configuration]
  def self.configure; yield configuration end
end

