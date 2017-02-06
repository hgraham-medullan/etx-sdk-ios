[![CircleCI](https://circleci.com/gh/medullan/etx-sdk-ios.svg?style=svg&circle-token=34d00690cd532c2b68f6c8a264045fb65c9c177c)](https://circleci.com/gh/medullan/etx-sdk-ios)

# EngaugeTx iOS SDK

## Getting Started

### CocoaPods
```
platform :ios, "8.0"
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/medullan/engauge-tx-pod-specs.git'

target 'EnguageTxSampleIosApp' do
  use_frameworks!
  pod 'EngaugeTx', '~> 0.0.8'
end
```

### Using the SDK
Create ```EngaugeTx.plist``` file with the following contents

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>appId</key>
        <string>your-app-id</string>
        <key>clientKey</key>
        <string>your-client-key</string>
        <key>baseUrl</key>
        <string>https://api.eu1.engaugetx.com/v1</string>
</dict>
</plist>
```
Properties that can be specified

| Property  | Type   | Description                                                                                   | Status   |
| --------- |:------:| :-----------                                                                                  |:--------:|
| appId     | string | Your application's ID                                                                         | required |
| clientKey | string | Your application's client key                                                                 | required |
| baseUrl   | string | The base URL to the EnguageTx instance. **Default:** https://api.us1.engaugetx.com/v1 | optional |

Start by implementing the ```EngaugeTxAppDelegate``` protocol and conforming to 
it by defining the ```engaugeTx``` instance variable.

```
import EngaugeTx
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, EngaugeTxAppDelegate {
  var window: UIWindow?
  var engaugeTx: EngaugeTxApplication?
```

Then instatiate it with an instance of ```EngaugeTxApplication```

```
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  engaugeTx = EngaugeTxApplication()
  return true
}
```

## Push Notifications

### Setup your app on firebase
The platform uses Firebase Cloud Messaging to send push notifications to users once the device token is registered. The first step is to [Set Up a Firebase Cloud Messaging Client App on iOS](https://firebase.google.com/docs/cloud-messaging/ios/client)

### Register the Device Token on the Platform

```
func tokenRefreshNotification(_ notification: Notification) {
  if let refreshedToken = FIRInstanceID.instanceID().token() {
    print("InstanceID token: \(refreshedToken)")
    let deviceToken: ETXDeviceToken = ETXDeviceToken(token: uniqueToken)
    deviceToken.save {
		(err) in
		guard let _ = err else {
			// Error handling
			return
		}
		print("Save Success")
	}

  }

  // Connect to FCM since connection may have failed when attempted before having a token.
  connectToFcm()
}
```

### Sending Push Notifications 
See the [server-side docs on how to send push notifications to a user](https://docs.google.com/document/d/1TVY-rapBHjKP04bqkBAP4iwhD1evIT4oUxnWJVZJR28/edit#heading=h.prwiyqm61465)
