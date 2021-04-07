require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class Influxdb2Helper
      # class methods that you define here become available in your action
      # as `Helper::Influxdb2Helper.your_method`
      #
      def self.show_message
        UI.message("Hello from the influxdb2 plugin helper!")
      end
    end
  end
end
