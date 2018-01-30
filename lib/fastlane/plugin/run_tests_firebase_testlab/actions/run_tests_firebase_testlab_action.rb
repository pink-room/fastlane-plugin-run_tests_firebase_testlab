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
          FastlaneCore::ConfigItem.new(key: :project_id,
                                       env_name: "PROJECT_ID",
                                       description: "Your Firebase project id",
                                       is_string: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :model,
                                       env_name: "MODEL",
                                       description: "The device model name to run the tests",
                                       is_string: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :version,
                                       env_name: "VERSION",
                                       description: "The Android api version of the device",
                                       is_string: true,
                                       optional: false),
          FastlaneCore::ConfigItem.new(key: :app_apk,
                                       env_name: "APP_APK",
                                       description: "The path for your app apk. Default: app/build/outputs/apk/debug/app-debug.apk",
                                       is_string: true,
                                       optional: true,
                                       default_value: "app/build/outputs/apk/debug/app-debug.apk"),
          FastlaneCore::ConfigItem.new(key: :android_test_apk,
                                       env_name: "ANDROID_TEST_APK",
                                       description: "The path for your android test apk. Default: app/build/outputs/apk/androidTest/debug/app-debug-androidTest.apk",
                                       is_string: true,
                                       optional: true,
                                       default_value: "app/build/outputs/apk/androidTest/debug/app-debug-androidTest.apk"),
          FastlaneCore::ConfigItem.new(key: locale,
                                       env_name: "LOCALE",
                                       description: "The locale to test against. Default: en_US",
                                       is_string: true,
                                       optional: true,
                                       default_value: "en_US"),
          FastlaneCore::ConfigItem.new(key: :orientation,
                                       env_name: "ORIENTATION",
                                       description: "The orientation of the device. Default: portrait",
                                       is_string: true,
                                       optional: true,
                                       default_value: "portrait"),
          FastlaneCore::ConfigItem.new(key: :timeout,
                                       env_name: "TIMEOUT",
                                       description: "The max time this test execution can run before it is cancelled. Default: 30m",
                                       is_string: true,
                                       optional: true,
                                       default_value: "30m"),
          FastlaneCore::ConfigItem.new(key: :output_dir,
                                       env_name: "OUTPUT_DIR",
                                       description: "The directory to save the output results. Default: firebase",
                                       is_string: true,
                                       optional: true,
                                       default_value: "firebase"),
          FastlaneCore::ConfigItem.new(key: :bucket_url,
                                       env_name: "BUCKET_URL",
                                       description: "The bucket url where the test results were stored. Default: Parsed automatically from tests output",
                                       is_string: true,
                                       optional: true,
                                       default_value: nil),
          FastlaneCore::ConfigItem.new(key: :delete_firebase_files,
                                       env_name: "DELETE_FIREBASE_FILES",
                                       description: "A flag to controll if the firebase files should be deleted from the bucket or not. Default: false",
                                       is_string: false,
                                       optional: true,
                                       default_value: false),
          FastlaneCore::ConfigItem.new(key: :extra_options,
                                       env_name: "EXTRA_OPTIONS",
                                       description: "Extra options that you need to pass to the gcloud command. Default: empty string",
                                       is_string: true,
                                       optional: true,
                                       default_value: ""),
          FastlaneCore::ConfigItem.new(key: :gcloud_service_key_file,
                                       env_name: "GCLOUD_SERVICE_KEY_FILE",
                                       description: "File path containing the gcloud auth key. Default: Created from GCLOUD_SERVICE_KEY environment variable",
                                       is_string: true,
                                       optional: true,
                                       default_value: nil)
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
