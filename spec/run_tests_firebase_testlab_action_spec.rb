describe Fastlane::Actions::RunTestsFirebaseTestlabAction do
  describe '#run' do
    minimum_sh_actions = 5
    let(:available_options) { Fastlane::Actions::RunTestsFirebaseTestlabAction.available_options }
    let(:test_console_output) { "Raw results will be stored in your GCS bucket at [https://console.developers.google.com/storage/browser/test-lab-s22/s22/]" }
    let(:test_console_output_file) { "instrumentation_output.txt" }
    let(:client_secret_file) { double("secret") }

    before :each do
      allow(Fastlane::UI).to receive(:message)
      allow(Fastlane::UI).to receive(:user_error!)
      allow(Fastlane::UI).to receive(:deprecated)

      allow(FileUtils).to receive(:mkdir_p)

      File.open(test_console_output_file, 'w') { |f| f.write(test_console_output) }
      allow(File).to receive(:open).with(Fastlane::Actions::RunTestsFirebaseTestlabAction.test_console_output_file).and_return(File.open(test_console_output_file))

      allow(File).to receive(:open).with(Fastlane::Actions::RunTestsFirebaseTestlabAction.client_secret_file, 'w').and_return(client_secret_file)
    end

    after :each do
      Fastlane::Actions::RunTestsFirebaseTestlabAction.run(@params)
      File.delete(Fastlane::Actions::RunTestsFirebaseTestlabAction.client_secret_file) if File.file?(Fastlane::Actions::RunTestsFirebaseTestlabAction.client_secret_file)
      File.delete(test_console_output_file)
    end

    it 'configures project' do
      generate_params
      expect_action_sh(minimum_sh_actions, Fastlane::Commands.config, "project-id")
    end

    context 'when no gcloud service file given' do
      it 'authenticates with created file' do
        generate_params
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.auth, Fastlane::Actions::RunTestsFirebaseTestlabAction.client_secret_file)
      end
    end

    context 'when gcloud service file given' do
      it 'authenticates with the given file' do
        generate_params({ gcloud_service_key_file: "keys.json" })
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.auth, "keys.json")
      end
    end

    context 'when no optional test params given' do
      it 'run tests with default app apk' do
        generate_params
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "--app #{@params[:app_apk]}")
      end

      it 'run tests with default android test apk' do
        generate_params
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "--test #{@params[:android_test_apk]}")
      end

      it 'run tests with given model' do
        generate_params
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "model=Nexus6P")
      end

      it 'run tests with given version' do
        generate_params
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "version=27")
      end

      it 'run tests with default locale' do
        generate_params
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "locale=#{@params[:locale]}")
      end

      it 'run tests with default orientation' do
        generate_params
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "orientation=#{@params[:orientation]}")
      end

      it 'run tests with default timeout' do
        generate_params
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "--timeout #{@params[:timeout]}")
      end
    end

    context 'when multiple devices given' do
      before do
        generate_params({ devices: [{ model: "Nexus6P", version: "27" }, { model: "Pixel", version: "22" }] })
      end

      it 'run tests with first model' do
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "model=Nexus6P")
      end

      it 'run tests with second model' do
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "model=Pixel")
      end

      it 'run tests with first version' do
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "version=27")
      end

      it 'run tests with second version' do
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "version=22")
      end
    end

    context 'when test optional params given' do
      before do
        generate_params({ app_apk: "app.apk", android_test_apk: "android_test.apk",
                          devices: [{ model: "Pixel", version: "22", locale: "pt_PT", orientation: "landscape" }],
                          timeout: "10m", extra_options: "--format=\"json\"" })
      end

      it 'run tests with the given app apk' do
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "--app app.apk")
      end

      it 'run tests with the given android test apk' do
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "--test android_test.apk")
      end

      it 'run tests with the given model' do
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "model=Pixel")
      end

      it 'run tests with the given version' do
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "version=22")
      end

      it 'run tests with the given locale' do
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "locale=pt_PT")
      end

      it 'run tests with the given orientation' do
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "orientation=landscape")
      end

      it 'run tests with the given timeout' do
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "--timeout 10m")
      end

      it 'run tests with the given extra options' do
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "--format=\"json\"")
      end
    end

    context 'when no output dir given' do
      it 'creates firebase dir' do
        generate_params
        expect(FileUtils).to receive(:mkdir_p).with("firebase")
      end
    end

    context 'when output dir given' do
      it 'creates the given dir' do
        generate_params({ output_dir: "output" })
        expect(FileUtils).to receive(:mkdir_p).with("output")
      end
    end

    context 'when bucket url not given' do
      it 'download results from url parsed from test command output' do
        generate_params
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.download_results, "gs://test-lab-s22/s22")
      end
    end

    context 'when bucket url given' do
      it 'downloads files from given url' do
        generate_params({ bucket_url: "gs://test-lab-1/1" })
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.download_results, "gs://test-lab-1/1")
      end
    end

    context 'when delete firebase files' do
      it 'deletes firebase files' do
        generate_params({ delete_firebase_files: true })
        expect_action_sh(minimum_sh_actions + 1, Fastlane::Commands.delete_resuls, "gs://test-lab-s22/s22")
      end
    end

    context 'when do not delete firebase files' do
      it 'do not delete firebase files' do
        generate_params
        expect_action_sh_not_to(minimum_sh_actions, Fastlane::Commands.delete_resuls)
      end
    end

    context 'when pipe exists' do
      it 'removes pipe file' do
        pipe = 'testlab-pipe'
        allow(File).to receive(:exist?).with(pipe).and_return(true)
        generate_params
        expect_action_sh(minimum_sh_actions + 2, 'rm', pipe)
      end
    end

    context 'when do not download firebase files' do
      it 'do not download firebase files' do
        generate_params({ download_results_from_firebase: false })
        expect_action_sh_not_to(minimum_sh_actions - 1, Fastlane::Commands.download_results)
      end
    end

    context 'when old and new device parameters given' do
      it 'crashes with a user error' do
        error_msg = "You can't use 'devices' param and 'model', 'version', 'locale' and 'orientation' params at the same time"
        generate_params({ model: "Pixel", version: "22" })
        expect(Fastlane::UI).to receive(:user_error!).with(error_msg)
      end
    end

    context 'when old device parameters given' do
      before do
        generate_params({ model: "Pixel", version: "22" })
      end

      it 'shows a deprecated message' do
        deprecated_msg = "The 'model', 'version', 'locale' and 'orientation' params are deprecated and will be removed in version 1.0!"
        expect(Fastlane::UI).to receive(:deprecated).with(deprecated_msg)
      end

      it 'run tests with the given model' do
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "model=Pixel")
      end

      it 'run tests with the given version' do
        expect_action_sh(minimum_sh_actions, Fastlane::Commands.run_tests, "version=22")
      end
    end

    def generate_params(new_params = {})
      needed_params = { project_id: "project-id", devices: [{ model: "Nexus6P", version: "27" }] }
      needed_params = needed_params.merge(new_params)
      @params = FastlaneCore::Configuration.create(available_options, needed_params)
    end

    def expect_action_sh(exactly, command, includes)
      expect(Fastlane::Action).to receive(:sh).exactly(exactly) do |c|
        expect(c).to include(includes) if c.start_with?(command)
      end
    end

    def expect_action_sh_not_to(exactly, command)
      expect(Fastlane::Action).to receive(:sh).exactly(exactly) do |c|
        expect(c).not_to(include(command))
      end
    end
  end
end
