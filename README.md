# run_tests_firebase_testlab plugin

[![fastlane Plugin Badge](https://rawcdn.githack.com/fastlane/fastlane/master/fastlane/assets/plugin-badge.svg)](https://rubygems.org/gems/fastlane-plugin-run_tests_firebase_testlab)
[![Build
Status](https://travis-ci.org/pink-room/fastlane-plugin-run_tests_firebase_testlab.svg?branch=master)](https://travis-ci.org/pink-room/fastlane-plugin-run_tests_firebase_testlab)
[![Gem
Version](https://badge.fury.io/rb/fastlane-plugin-run_tests_firebase_testlab.svg)](https://badge.fury.io/rb/fastlane-plugin-run_tests_firebase_testlab)

Please, read [this](https://medium.com/pink-room-club/android-continuous-integration-using-fastlane-and-circleci-2-0-part-i-7204e2e7b8b) blog post if you want to know better how to use this plugin.

## Getting Started

This project is a [_fastlane_](https://github.com/fastlane/fastlane) plugin. To get started with `fastlane-plugin-run_tests_firebase_testlab`, add it to your project by running:
```bash
fastlane add_plugin run_tests_firebase_testlab
```

## About run_tests_firebase_testlab

* Authenticates with Google Cloud.

* Runs Android tests in Firebase Test Lab.

* Fetches the results to a local directory.

* Deletes the results from firebase bucket if wanted.

## Example

Check out the [example `Fastfile`](fastlane/Fastfile) to see how to use this plugin.

### Simple usage

```
run_tests_firebase_testlab(
    project_id: "your-firebase-project-id",
    devices: [
      {
        model: "Nexus6P",
        version: "27"
      }
    ]);
```

### Parameters

<table>
<thead>
<tr>
<th>Parameter</th>
<th>Description</th>
<th>Optional</th>
<th>Default</th>
</tr>
</thead>
<tbody>

<tr>
<td><b>project_id</b></td>
<td>Your Firebase project id</td>
<td>No</td>
<td>-</td>
</tr>

<tr>
<td><b>devices</b></td>
<td>A list of devices to test the App on</td>
<td>No</td>
<td>-</td>
</tr>

<tr>
<td><b>device[model]</b></td>
<td>A device model on which the tests will run</td>
<td>No</td>
<td>-</td>
</tr>

<tr>
<td><b>device[version]</b></td>
<td>The Android api version of the device</td>
<td>No</td>
<td>-</td>
</tr>

<tr>
<td>device[locale]</td>
<td>The locale to test against</td>
<td>Yes</td>
<td>en_US</td>
</tr>

<tr>
<td>device[orientation]</td>
<td>The orientation of the device</td>
<td>Yes</td>
<td>portrait</td>
</tr>

<tr>
<td>app_apk</td>
<td>The path for your app apk</td>
<td>Yes</td>
<td>app/build/outputs/apk/debug/<br>app-debug.apk</td>
</tr>

<tr>
<td>android_test_apk</td>
<td>The path for your android test apk</td>
<td>Yes</td>
<td>app/build/outputs/apk/androidTest/<br>debug/app-debug-androidTest.apk</td>
</tr>

<tr>
<td>timeout</td>
<td>The max time this test execution can run before it is cancelled</td>
<td>Yes</td>
<td>30m</td>
</tr>

<tr>
<td>output_dir</td>
<td>The directory to save the output results</td>
<td>Yes</td>
<td>firebase</td>
</tr>

<tr>
<td>bucket_url</td>
<td>The bucket url where the test results were stored</td>
<td>Yes</td>
<td>Parsed automatically from tests output</td>
</tr>

<tr>
<td>delete_firebase_files</td>
<td>A flag to control if the firebase files should be deleted from the bucket or not</td>
<td>Yes</td>
<td>false</td>
</tr>

<tr>
<td>extra_options</td>
<td>Extra options that you need to pass to the gcloud command</td>
<td>Yes</td>
<td>empty string</td>
</tr>

<tr>
<td>gcloud_service_key_file</td>
<td>File path containing the gcloud auth key</td>
<td>Yes</td>
<td>Created from GCLOUD_SERVICE_KEY environment variable</td>
</tr>

<tr>
<td>download_results_from_firebase</td>
<td>A flag to control if the firebase files should be downloaded from the bucket or not</td>
<td>Yes</td>
<td>true</td>
</tr>

<tr>
<td>download_file_list</td>
<td>A list of files that should be downloaded from the bucket. This is an additional parameter for 'download_results_from_firebase'</td>
<td>Yes</td>
<td>empty array</td>
</tr>

</tbody>
</table>

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
