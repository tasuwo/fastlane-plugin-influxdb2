require 'influxdb-client'

describe Fastlane::Actions::Influxdb2Action do
  describe '#run' do
    let(:measurement) { 'metrics' }
    let(:fields) do
      {
        a: 0.1,
        b: 1,
        c: "foo",
        d: true
      }
    end
    let(:params) do
      {
        host: 'https://localhost:8086',
        token: 'my-token',
        bucket_name: 'my-bucket',
        organization_name: 'my-org',
        precision: InfluxDB2::WritePrecision::NANOSECOND,
        open_timeout: 10,
        write_timeout: 10,
        read_timeout: 10,
        max_redirect_count: 10,
        use_ssl: true,
        verify_mode: OpenSSL::SSL::VERIFY_NONE,
        measurement: measurement,
        fields: fields
      }
    end

    context 'with only field set' do
      before do
        write_api_mock = double('Write API')
        allow(write_api_mock).to receive(:write)
          .with({ data: "metrics a=0.1,b=1,c=\"foo\",d=true" })
        allow_any_instance_of(InfluxDB2::Client).to receive(:create_write_api)
          .and_return(write_api_mock)
      end

      it 'Write `metrics a=1,b=2` to InfluxDB' do
        expect(Fastlane::UI).to receive(:success).with("Successfully posted data to '#{measurement}'")
        Fastlane::Actions::Influxdb2Action.run(params)
      end
    end

    context 'with field set and tag set' do
      before do
        write_api_mock = double('Write API')
        allow(write_api_mock).to receive(:write)
          .with({ data: "metrics,x=foo,y=bar a=0.1,b=1,c=\"foo\",d=true" })
        allow_any_instance_of(InfluxDB2::Client).to receive(:create_write_api)
          .and_return(write_api_mock)
      end

      it 'Write `metrics,x=foo,y=bar a=1,b=2` to InfluxDB' do
        expect(Fastlane::UI).to receive(:success).with("Successfully posted data to '#{measurement}'")
        Fastlane::Actions::Influxdb2Action.run(params.merge({ tags: { x: "foo", y: "bar" } }))
      end
    end

    context 'with field set, tag set, and timestamp' do
      before do
        write_api_mock = double('Write API')
        allow(write_api_mock).to receive(:write)
          .with({ data: "metrics,x=foo,y=bar a=0.1,b=1,c=\"foo\",d=true 12345" })
        allow_any_instance_of(InfluxDB2::Client).to receive(:create_write_api)
          .and_return(write_api_mock)
      end

      it 'Write `metrics,x=foo,y=bar a=0.1,b=1,c="foo",d=true 12345` to InfluxDB' do
        expect(Fastlane::UI).to receive(:success).with("Successfully posted data to '#{measurement}'")
        Fastlane::Actions::Influxdb2Action.run(params.merge({ tags: { x: "foo", y: "bar" }, timestamp: 12_345 }))
      end
    end

    context 'with invalid parameter' do
      let(:response) { { error: 'authorization failed' } }
      before do
        write_api_mock = double('Write API')
        allow(write_api_mock).to receive(:write)
          .with({ data: "metrics a=0.1,b=1,c=\"foo\",d=true" })
          .and_raise("authorization failed")
        allow_any_instance_of(InfluxDB2::Client).to receive(:create_write_api)
          .and_return(write_api_mock)
      end

      it 'Raise user_error from response' do
        expect(Fastlane::UI).to receive(:user_error!).with("authorization failed")
        Fastlane::Actions::Influxdb2Action.run(params)
      end
    end
  end
end
