# influxdb2 plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-influxdb2)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-influxdb2`, add it to your project by add the following to the `Pluginfile`:

```ruby
gem "fastlane-plugin-influxdb2", git: "https://github.com/tasuwo/fastlane-plugin-influxdb2"
```

## About influxdb2

Writes data into InfluxDB 2.0.

```ruby
lane :your_lane do
   influxdb2(
       host: "https://localhost:8086",
       token: "my-token",
       bucket_name: "my-bucket",
       organization_name: "my-org",
       use_ssl: true,
       measurement: "metrics",
       tags: {tag1: "foo", tag2: "bar"},
       fields: {a: 0.1, b: 1, c: "foo", d: true}
   )
end
```

## Run tests for this plugin

To run both the tests, and code style validation, run

```
rake
```

To automatically fix many of the styling issues, use
```
rubocop -a
```

## Issues and Feedback

For any other issues and feedback about this plugin, please submit it to this repository.

## Troubleshooting

If you have trouble using plugins, check out the [Plugins Troubleshooting](https://docs.fastlane.tools/plugins/plugins-troubleshooting/) guide.

## Using _fastlane_ Plugins

For more information about how the `fastlane` plugin system works, check out the [Plugins documentation](https://docs.fastlane.tools/plugins/create-plugin/).

## About _fastlane_

_fastlane_ is the easiest way to automate beta deployments and releases for your iOS and Android apps. To learn more, check out [fastlane.tools](https://fastlane.tools).
