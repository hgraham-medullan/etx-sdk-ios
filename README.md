# EnguageTx iOS SDK

## Getting Started

### CocoaPods
```
platform :ios, "8.0"
source 'https://gitlab.com/engaugetx/EngaugeTxPodSpecs.git'

target 'EnguageTxSampleIosApp' do
  use_frameworks!
  pod 'EngaugeTx', '~> 0.0.1'
end
```

### Using the SDK
Start by implementing the ```EngaugeTxAppDelegate``` protocol and conforming to 
it by defining the ```engaugeTx``` instance variable.
```
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


## Documentation
Our docs can be found here: [docs](https://medullan.github.io/etx-sdk-ios/)
