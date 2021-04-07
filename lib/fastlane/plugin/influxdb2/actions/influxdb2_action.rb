require 'influxdb-client'
require 'fastlane/action'
require_relative '../helper/influxdb2_helper'

module Fastlane
  module Actions
    class Influxdb2Action < Action
      def self.run(params)
        client = InfluxDB2::Client.new(
          params[:host],
          params[:token],
          bucket: params[:bucket_name],
          org: params[:organization_name],
          precision: params[:precision],
          open_timeout: params[:open_timeout],
          write_timeout: params[:write_timeout],
          read_timeout: params[:read_timeout],
          max_redirect_count: params[:max_redirect_count],
          use_ssl: params[:use_ssl],
          verify_mode: params[:verify_mode]
        )

        write_api = client.create_write_api

        data = []
        data << params[:measurement]
        data << ',' + params[:tags].map { |k, v| k.to_s + '=' + v.to_s }.join(',').to_s if params[:tags]
        data << ' ' + params[:fields].map { |k, v| "#{k}=#{v.kind_of?(String) ? "\"#{v}\"" : v.to_s}" }.join(',').to_s
        data << ' ' + params[:timestamp].to_s if params[:timestamp]

        begin
          write_api.write(data: data.join)
          UI.success("Successfully posted data to '#{params[:measurement]}'")
        rescue StandardError => e
          UI.user_error!(e.message)
        end
      end

      def self.description
        "Post values to InfluxDB2 from your lane."
      end

      def self.authors
        ["tasuwo"]
      end

      def self.return_value
        "nil or error message"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :host,
                                       env_name: "INFLUXDB2_HOST",
                                       description: "Host of InfluxDB",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :token,
                                       env_name: "INFLUXDB2_TOKEN",
                                       description: "Authentication token to authorize requests",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :bucket_name,
                                       env_name: "INFLUXDB2_BUCKET_NAME",
                                       description: "Bucket name of InfluxDB",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :organization_name,
                                       env_name: "INFLUXDB2_ORGANIZATION_NAME",
                                       description: "Organization name of InfluxDB",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :precision,
                                       env_name: "INFLUXDB2_PRECISION",
                                       description: "Default precision for the unix timestamps within the body line-protocol",
                                       optional: true,
                                       default_value: InfluxDB2::WritePrecision::NANOSECOND,
                                       default_value_dynamic: true,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :open_timeout,
                                       env_name: "INFLUXDB2_OPEN_TIMEOUT",
                                       description: "Number of seconds to wait for the connection to open",
                                       optional: true,
                                       default_value: 10,
                                       type: Integer),
          FastlaneCore::ConfigItem.new(key: :write_timeout,
                                       env_name: "INFLUXDB2_WRITE_TIMEOUT",
                                       description: "Number of seconds to wait for one block of data to be written",
                                       optional: true,
                                       default_value: 10,
                                       type: Integer),
          FastlaneCore::ConfigItem.new(key: :read_timeout,
                                       env_name: "INFLUXDB2_READ_TIMEOUT",
                                       description: "Number of seconds to wait for one block of data to be read",
                                       optional: true,
                                       default_value: 10,
                                       type: Integer),
          FastlaneCore::ConfigItem.new(key: :max_redirect_count,
                                       env_name: "INFLUXDB2_MAX_REDIRECT_COUNT",
                                       description: "Maximal number of followed HTTP redirects",
                                       optional: true,
                                       default_value: 10,
                                       type: Integer),
          FastlaneCore::ConfigItem.new(key: :use_ssl,
                                       env_name: "INFLUXDB2_USE_SSL",
                                       description: "Turn on/off SSL for HTTP communication",
                                       optional: true,
                                       default_value: true,
                                       is_string: false,
                                       type: Boolean),
          FastlaneCore::ConfigItem.new(key: :verify_mode,
                                       env_name: "INFLUXDB2_VERIFY_MODE",
                                       description: "Sets the flags for the certification verification at beginning of SSL/TLS session",
                                       optional: true,
                                       default_value: OpenSSL::SSL::VERIFY_NONE,
                                       default_value_dynamic: true,
                                       verify_block: proc do |value|
                                         modes = [
                                           OpenSSL::SSL::VERIFY_NONE,
                                           OpenSSL::SSL::VERIFY_PEER
                                         ]
                                         UI.user_error!("Unsupported verify mode, must be: #{modes}") unless modes.include?(value)
                                       end,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :measurement,
                                       env_name: "INFLUXDB2_MEASUREMENT",
                                       description: "The measurement name",
                                       optional: false,
                                       type: String),
          FastlaneCore::ConfigItem.new(key: :tags,
                                       description: "Tag set to write",
                                       optional: true,
                                       type: Hash),
          FastlaneCore::ConfigItem.new(key: :fields,
                                       description: "Field set to write",
                                       optional: false,
                                       type: Hash),
          FastlaneCore::ConfigItem.new(key: :timestamp,
                                       description: "Timestamp of a data point",
                                       optional: true,
                                       type: Integer)
        ]
      end

      def self.example_code
        [
          'influxdb2(
            host: "https://localhost:8086",
            token: "my-token",
            bucket_name: "my-bucket",
            organization_name: "my-org",
            use_ssl: true,
            measurement: "metrics",
            tags: {tag1: "foo", tag2: "bar"},
            fields: {a: 0.1, b: 1, c: "foo", d: true}
          )'
        ]
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end
