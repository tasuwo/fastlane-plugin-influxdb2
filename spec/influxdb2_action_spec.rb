describe Fastlane::Actions::Influxdb2Action do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The influxdb2 plugin is working!")

      Fastlane::Actions::Influxdb2Action.run(nil)
    end
  end
end
