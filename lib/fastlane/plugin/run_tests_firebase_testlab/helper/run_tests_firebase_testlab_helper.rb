require 'fastlane_core/ui/ui'

module Fastlane
  UI = FastlaneCore::UI unless Fastlane.const_defined?("UI")

  module Helper
    class RunTestsFirebaseTestlabHelper
      # class methods that you define here become available in your action
      # as `Helper::RunTestsFirebaseTestlabHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the run_tests_firebase_testlab plugin helper!")
      end
    end
  end
end
