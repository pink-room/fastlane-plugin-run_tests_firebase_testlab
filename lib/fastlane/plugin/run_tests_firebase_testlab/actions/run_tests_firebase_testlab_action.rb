module Fastlane
  module Actions
    class RunTestsFirebaseTestlabAction < Action
      PIPE = "testlab-pipe"
      @client_secret_file = "client-secret.json"
      @test_console_output_file = "instrumentation_output.txt"
      @test_console_folder_list_output_file = "folder_list.txt"

      class << self
        attr_reader :client_secret_file, :test_console_output_file
      end

      def self.run(params)
        UI.message("Starting run_tests_firebase_testlab plugin...")

        validate_params(params)

        if params[:gcloud_service_key_file].nil?
          UI.message("Save Google Cloud credentials.")
          File.open(@client_secret_file, 'w') do |file|
            file.write(ENV["GCLOUD_SERVICE_KEY"])
          end
        else
          @client_secret_file = params[:gcloud_service_key_file]
        end

        UI.message("Set Google Cloud target project.")
        Action.sh("#{Commands.config} #{params[:project_id]}")

        UI.message("Authenticate with Google Cloud.")
        Action.sh("#{Commands.auth} --key-file #{@client_secret_file}")

        UI.message("Running instrumentation tests in Firebase Test Lab...")
        remove_pipe_if_exists
        Action.sh("mkfifo #{PIPE}")

        begin
          Action.sh("tee #{@test_console_output_file} < #{PIPE} & "\
                    "#{Commands.run_tests} "\
                    "--type instrumentation "\
                    "--app #{params[:app_apk]} "\
                    "--test #{params[:android_test_apk]} "\
                    "#{create_devices_params(params)}"\
                    "--timeout #{params[:timeout]} "\
                    "#{params[:extra_options]} > #{PIPE} 2>&1")
        ensure
          remove_pipe_if_exists

          UI.message("Create firebase directory (if not exists) to store test results.")
          FileUtils.mkdir_p(params[:output_dir])

          if params[:bucket_url].nil?
            UI.message("Parse firebase bucket url.")
            params[:bucket_url] = scrape_bucket_url
            UI.message("bucket: #{params[:bucket_url]}")
          end

          if params[:download_results_from_firebase]
            if params[:download_file_list].length > 0
              download_files_from_list(params)
            else
              download_all_files(params)
            end
          end

          if params[:delete_firebase_files]
            UI.message("Deleting files from firebase storage...")
            Action.sh("#{Commands.delete_resuls} #{params[:bucket_url]}")
          end
        end
      end

      def self.description
        "Runs Android tests in Firebase Test Lab."
      end

      def self.authors
        ["bffcorreia"]
      end

      def self.details
        [
          "Authenticates with Google Cloud.",
          "Runs tests in Firebase Test Lab.",
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
          FastlaneCore::ConfigItem.new(key: :devices,
                                       env_name: "DEVICES",
                                       description: "Devices to test the App on",
                                       type: Array,
                                       optional: true,
                                       verify_block: proc do |devices|
                                         devices.each do |d|
                                           if d.class != Hash
                                             UI.user_error!("Each device must be represented by a Hash object, #{d.class} found")
                                           end
                                           check_has_property(d, :model)
                                           check_has_property(d, :version)
                                           set_default_property(d, :locale, "en_US")
                                           set_default_property(d, :orientation, "portrait")
                                         end
                                       end),
          FastlaneCore::ConfigItem.new(key: :model,
                                       env_name: "MODEL",
                                       description: "The device's model on which the tests will be run",
                                       is_string: true,
                                       optional: true),
          FastlaneCore::ConfigItem.new(key: :version,
                                       env_name: "VERSION",
                                       description: "The Android api version of the device",
                                       is_string: true,
                                       optional: true),
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
          FastlaneCore::ConfigItem.new(key: :locale,
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
                                       default_value: nil),
          FastlaneCore::ConfigItem.new(key: :download_results_from_firebase,
                                       env_name: "SHOULD_DOWNLOAD_FROM_FIREBASE",
                                       description: "A flag to control if the firebase files should be downloaded from the bucket or not. Default: true",
                                       is_string: false,
                                       optional: true,
                                       default_value: true),
          FastlaneCore::ConfigItem.new(key: :download_file_list,
                                       env_name: "DOWNLOAD_FILE_LIST",
                                       description: "A list of files that should be downloaded from the bucket. This is an additional parameter for 'download_results_from_firebase'.",
                                       type: Array,
                                       optional: true,
                                       default_value: [])
        ]
      end

      def self.is_supported?(platform)
        platform == :android
      end

      def self.example_code
        [
          'run_tests_firebase_testlab(
              project_id: "your-firebase-project-id",
              devices: [
                {
                  model: "Nexus6P",
                  version: "27"
                }
              ],
              delete_firebase_files: true
          )'
        ]
      end

      def self.category
        :testing
      end

      def self.check_has_property(device, property)
        UI.user_error!("Each device must have #{property} property") unless device.key?(property)
      end

      private_class_method :check_has_property

      def self.set_default_property(device, property, default)
        unless device.key?(property)
          device[property] = default
        end
      end

      private_class_method :set_default_property

      def self.validate_params(params)
        if has_old_device_params(params)
          UI.deprecated("The 'model', 'version', 'locale' and 'orientation' params are deprecated and will be removed in version 1.0!")
          unless params[:devices].nil?
            UI.user_error!("You can't use 'devices' param and 'model', 'version', "\
                           "'locale' and 'orientation' params at the same time")
          end
        end
      end

      private_class_method :validate_params

      def self.has_old_device_params(params)
        !(params[:model].nil? || params[:version].nil? || params[:locale].nil? || params[:orientation].nil?)
      end

      private_class_method :has_old_device_params

      def self.create_devices_params(params)
        if has_old_device_params(params)
          params[:devices] = [
            {
              model: params[:model],
              version: params[:version],
              locale: params[:locale],
              orientation: params[:orientation]
            }
          ]
        end

        devices_params = ""

        params[:devices].each do |device|
          devices_params += create_device_param(device)
        end

        devices_params
      end

      private_class_method :create_devices_params

      def self.create_device_param(device)
        "--device model=#{device[:model]},version=#{device[:version]},locale=#{device[:locale]},orientation=#{device[:orientation]} "
      end

      private_class_method :create_device_param

      def self.scrape_bucket_url
        File.open(@test_console_output_file).each do |line|
          url = line.scan(/\[(.*)\]/).last&.first
          next unless !url.nil? and (!url.empty? and url.include?("test-lab-"))
          splitted_url = url.split("/")
          length = splitted_url.length
          return "gs://#{splitted_url[length - 2]}/#{splitted_url[length - 1]}"
        end
      end

      private_class_method :scrape_bucket_url

      def self.remove_pipe_if_exists
        Action.sh("rm #{PIPE}") if File.exist?(PIPE)
      end

      private_class_method :remove_pipe_if_exists

      def self.download_files_from_list(params)
        UI.message("Get files from bucket...")

        Action.sh("#{Commands.list_object} "\
                  "#{params[:bucket_url]} "\
                  "| grep -e '/$' > #{@test_console_folder_list_output_file}")

        bucket_path = params[:bucket_url].delete_prefix("gs://")

        device_folders = []
        File.open(@test_console_folder_list_output_file).each do |line|
          folder = line.match(%r{#{bucket_path}/(.*)/$}).captures.first
          device_folders.push(folder)
        end

        device_folders.each do |folder|
          params[:download_file_list].each do |filename|
            UI.message("Download file '#{filename}' from '#{folder}' to '#{params[:output_dir]}/#{folder}/#{filename}'...")
            Action.sh("#{Commands.download_single_file} #{params[:bucket_url]}/#{folder}/#{filename} #{params[:output_dir]}/#{folder}/#{filename}")
          end
        end
      end

      private_class_method :download_files_from_list

      def self.download_all_files(params)
        UI.message("Downloading instrumentation test results from Firebase Test Lab...")
        Action.sh("#{Commands.download_results} #{params[:bucket_url]} #{params[:output_dir]}")
      end

      private_class_method :download_all_files
    end
  end
end
