require 'fastlane/action'
require_relative '../helper/run_tests_firebase_testlab_helper'

module Fastlane
  module Actions
    class RunTestsFirebaseTestlabAction < Action
      def self.run(params)
        UI.message("The run_tests_firebase_testlab plugin is working!")
      end

      def self.description
        "Runs Android tests in Firebase testlab."
      end

      def self.authors
        ["bffcorreia"]
      end

      def self.details
        [
          "Authenticates with Google Cloud.",
          "Runs tests in Firebase testlab.",
          "Fetches the results to a local directory.",
          "Deletes the results from firebase bucket if wanted."
        ].join("\n")
      end

      def self.output
        [
          ['bugreport.txt', 'A bugreport of the app.'],
          ['instrumentation.results', 'The results of the instrumentation tests.'],
          ['logcat', 'Logs from logcat.'],
          ['test_result_0.xml', 'A xml file that contains all the tests.'],
          ['video.mp4', 'A video of the tests.']
        ]
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "RUN_TESTS_FIREBASE_TESTLAB_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        platform == :android
      end

      def self.example_code
        [
          'run_tests_firebase_testlab(
              project_id: "your-firebase-project-id",
              model: "Nexus6P",
              version: "27",
              delete_firebase_files: true
          )'
        ]
      end

      def self.category
        :testing
      end
    end
  end
end
