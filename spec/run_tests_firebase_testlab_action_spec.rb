describe Fastlane::Actions::RunTestsFirebaseTestlabAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The run_tests_firebase_testlab plugin is working!")

      Fastlane::Actions::RunTestsFirebaseTestlabAction.run(nil)
    end
  end
end
