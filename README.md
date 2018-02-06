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

* Authenticates with Google Cloud.

* Runs Android tests in Firebase testlab.

* Fetches the results to a local directory.

* Deletes the results from firebase bucket if wanted.

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
<td>false</td>
<td>-</td>
</tr>

<tr>
<td><b>model</b></td>
<td>The device's model on which the tests will be run</td>
<td>false</td>
<td>-</td>
</tr>

<tr>
<td><b>version</b></td>
<td>The Android api version of the device</td>
<td>false</td>
<td>-</td>
</tr>

<tr>
<td>app_apk</td>
<td>The path for your app apk</td>
<td>true</td>
<td>app/build/outputs/apk/debug/<br>app-debug.apk</td>
</tr>

<tr>
<td>android_test_apk</td>
<td>The path for your android test apk</td>
<td>true</td>
<td>app/build/outputs/apk/androidTest/<br>debug/app-debug-androidTest.apk</td>
</tr>

<tr>
<td>locale</td>
<td>The locale to test against</td>
<td>true</td>
<td>en_US</td>
</tr>

<tr>
<td>orientation</td>
<td>The orientation of the device</td>
<td>true</td>
<td>portrait</td>
</tr>

<tr>
<td>timeout</td>
<td>The max time this test execution can run before it is cancelled</td>
<td>true</td>
<td>30m</td>
</tr>

<tr>
<td>output_dir</td>
<td>The directory to save the output results</td>
<td>true</td>
<td>firebase</td>
</tr>

<tr>
<td>bucket_url</td>
<td>The bucket url where the test results were stored</td>
<td>true</td>
<td>Parsed automatically from tests output</td>
</tr>

<tr>
<td>delete_firebase_files</td>
<td>A flag to control if the firebase files should be deleted from the bucket or not</td>
<td>true</td>
<td>false</td>
</tr>

<tr>
<td>extra_options</td>
<td>Extra options that you need to pass to the gcloud command</td>
<td>true</td>
<td>empty string</td>
</tr>

<tr>
<td>gcloud_service_key_file</td>
<td>File path containing the gcloud auth key</td>
<td>true</td>
<td>Created from GCLOUD_SERVICE_KEY environment variable</td>
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
