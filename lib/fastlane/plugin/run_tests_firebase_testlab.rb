require 'fastlane/plugin/run_tests_firebase_testlab/version'

module Fastlane
  module RunTestsFirebaseTestlab
    # Return all .rb files inside the "actions" and "commands" directory
    def self.all_classes
      Dir[File.expand_path('**/{actions,commands}/*.rb', File.dirname(__FILE__))]
    end
  end
end

# By default we want to import all available actions and helpers
# A plugin can contain any number of actions and plugins
Fastlane::RunTestsFirebaseTestlab.all_classes.each do |current|
  require current
end
