# run_tests_firebase_testlab plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-run_tests_firebase_testlab)
[![Build
Status](https://travis-ci.org/pink-room/fastlane-plugin-run_tests_firebase_testlab.svg?branch=master)](https://travis-ci.org/pink-room/fastlane-plugin-run_tests_firebase_testlab)

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-run_tests_firebase_testlab`, add it to your project by running:

```bash
fastlane add_plugin run_tests_firebase_testlab
```

## About run_tests_firebase_testlab

Authenticates with Google Cloud.
Runs Android tests in Firebase testlab.
Fetches the results to a local directory.
Deletes the results from firebase bucket if wanted.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin.

### Simple usage

```
run_tests_firebase_testlab(
    project_id: "your-firebase-project-id",
    model: "Nexus6P",
    version: "27")
```

### Parameters

- `project_id`: Your Firebase project id. This parameter is necessary.
- `model`: The device model name to run the tests. This parameter is necessary.
- `version`: The Android api version of the device. This parameter is necessary.
- `app_apk`: The path for your app apk. Default: app/build/outputs/apk/debug/app-debug.apk
- `android_test_apk`: The path for your android test apk. Default: app/build/outputs/apk/androidTest/debug/app-debug-androidTest.apk
- `locale`: The locale to test against. Default: en_US
- `orientation`: The orientation of the device. Default: portrait
- `timeout`: The max time this test execution can run before it is cancelled. Default: 30m
- `output_dir`: The directory to save the output results. Default: firebase
- `bucket_url`: The bucket url where the test results were stored. Default: Parsed automatically from tests output
- `delete_firebase_files`: A flag to control if the firebase files should be deleted from the bucket or not. Default: false
- `extra_options`: Extra options that you need to pass to the gcloud command. Default: empty string
- `gcloud_service_key_file`: File path containing the gcloud auth key. Default: Created from GCLOUD_SERVICE_KEY environment variable

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
