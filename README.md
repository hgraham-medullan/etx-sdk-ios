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
  pod 'EngaugeTx', '~> 0.0.33'
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

```swift
import EngaugeTx
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, EngaugeTxAppDelegate {
  var window: UIWindow?
  var engaugeTx: EngaugeTxApplication?
```

Then instatiate it with an instance of ```EngaugeTxApplication```

```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  engaugeTx = EngaugeTxApplication()
  return true
}
```

## Creating a custom User

```swift
class Customer: ETXUser {
	var hiddenField: String // Do not add to mapping function to prevent persistence
	var worth: Float!
	var dateOfBirth: Date!
	
	override func mapping(map: Map) {
		super.mapping(map: map)
		worth <- map["worth"]
		dateOfBirth <- (map["dateOfBirth"], ETXDateTransform()) // To ensure dates are fomatted to/from the platforms date fromat when serializing/de-serializing
	}
}
```


## Search Filters

### Using one condition
Finding an item by one condition

```swift
let weightCondition: ETXWhereCondition = ETXWhereCondition(property: "weight", comparator: .gt, value: 100)
let searchFilter: ETXSearchFilter = ETXSearchFilter(condition: weightCondition)
```

### Using a Date

```swift
let priorToNow: ETXWhereCondition = ETXWhereCondition(property: "createdAt", comparator: .lte, value: Date())
let searchFilter: ETXSearchFilter = ETXSearchFilter(condition: priorToNow)
```

### Using Multiple conditions 
For the conditions below:

```swift
let weightCondition: ETXWhereCondition = ETXWhereCondition(property: "weight", comparator: .gt, value: 20)
let nameCondition: ETXWhereCondition = ETXWhereCondition(property: "name", comparator: .eq, value: "Sean")
let conditions: [ETXCondition] = [weightCondition, nameCondition]
```

You can filter where all conditions are true

```swift
let searchFilter: ETXSearchFilter = ETXSearchFilter(conditions: conditions)
```
Alternatively, AND conditions can be written as 

```swift
let searchFilter: ETXSearchFilter = ETXSearchFilter(condition: ETXCombinedCondition(combineType: .and, conditions: conditions))
```


As well as where only one condition is true

```swift
let searchFilter: ETXSearchFilter = ETXSearchFilter(condition: ETXCombinedCondition(combineType: .or, conditions: conditions)
```

### Combining AND and OR conditions

```swift
let females: ETXWhereCondition = ETXWhereCondition(property: "gender", comparator: .eq, value: "Female")
let adultAge: ETXWhereCondition = ETXWhereCondition(property: "age", comparator: .gte, value: 18)
let males: ETXWhereCondition = ETXWhereCondition(property: "gender", comparator: .eq, value: "Male")
        
let maleOrFemale: ETXCombinedCondition = ETXCombinedCondition(combineType: .or, conditions: [females, males])
let adultMaleOrFemale: ETXCombinedCondition = ETXCombinedCondition(combineType: .and, conditions: [adultAge, maleOrFemale])
        
let searchFilter: ETXSearchFilter = ETXSearchFilter(conditions: adultMaleOrFemale);
```

### Writing custom filters

> **For complex/large queries, please [reach out to Platform team](http://help.engaugetx.com/) to ensure that your queries are performant** 
 
If the API doesn't meet your needs, you can write your own filter query using [Loopback's query formats](https://loopback.io/doc/en/lb2/Querying-data.html). 

```swift
let filterQuery: String = "{\"where\":{\"weight\":{\"gt\":20}}}";
let searchFilter: ETXSearchFilter = ETXSearchFilter(customFilter: filterQuery);
```

## Push Notifications

### Setup your app on firebase
The platform uses Firebase Cloud Messaging to send push notifications to users once the device token is registered. The first step is to [Set Up a Firebase Cloud Messaging Client App on iOS](https://firebase.google.com/docs/cloud-messaging/ios/client)

#### Provide the Platform with your server key

In [your firebase console](https://console.firebase.google.com/), select your project, then go to `Settings` > `Cloud Messaging` and share your `Server key` with the platform team.

### Register the Device Token on the Platform

```swift
func tokenRefreshNotification(_ notification: Notification) {
  if let refreshedToken = FIRInstanceID.instanceID().token() {
    print("InstanceID token: \(refreshedToken)")
    let deviceToken: ETXDeviceToken = ETXDeviceToken(token: refreshedToken)
    deviceToken.save {
		(err) in
		if let err = err else {
			// handling err
		} else {
		   print("Save Success")
		}
	}
  }

  // Connect to FCM since connection may have failed when attempted before having a token.
  connectToFcm()
}
```

### Sending Push Notifications 
See the [server-side docs on how to send push notifications to a user](https://docs.google.com/document/d/1TVY-rapBHjKP04bqkBAP4iwhD1evIT4oUxnWJVZJR28/edit#heading=h.prwiyqm61465)

## Data Trends

Aggregated data can be fetched using the [ETXTrendsService](https://iosdocs.engaugetx.com/Classes/ETXTrendService.html) class

### Getting aggregated data over a timeframe of two weeks
The following will get aggregated date for IndoorAirQuality and Steps over a two week period leading up to the current day

```swift
class MyCustomIndoorAirQuality: ETXIndoorAirQuality { }

ETXTrendService.getTrend(trendTimeframe: .TwoWeeks, forClasses: [MyCustomIndoorAirQuality.self, ETXSteps.self]) {
  (trendResultSet: ETXTrendResultSet?, err: ETXError?) in
  
  if let err = err {
    // handle err
  }
  
  // Grab the data individually 
  let indoorAirQualityTrendResult: ETXClassTrendResultSet = trendResultSet?.getTrendForClass(ETXIndoorAirQuality.self)!
  
  // View the aggregated data for each day for the two weeks
  indoorAirQualityTrendResult.values?.forEach({
    (aggregatedData: ETXAggregatable) in
      print("Average indoor air quality for \(aggregatedData.date) is \(aggregatedData.value)")
  })
  
  print("The average air quality over the 2-week timeframe is \(indoorAirQualityTrendResult.timeframe?.average) )
}

let stepsTrendResult: ETXClassTrendResultSet = trendResultSet?.getTrendForClass(ETXSteps.self)!
...
```

## Affiliation

As a Caregiver get a list of all my Patients

```swift
let service = ETXAffiliationService()
service.getAffiliatedUsers(withRole: ETXRole.patient, forMyRole: ETXRole.caregiver){
    (patients, err) in
    // err is nil when successful
    // patients -> [ETXUser] // only firstName, lastName and id are populated
}
```
## Data Trends

Aggregated data can be fetched using the ETXTrendService class

### Getting aggregated data over a timeframe of two weeks
The following will get aggregated date for IndoorAirQuality and Steps over a two week period leading up to the current day

```swift
let classes = [ETXIndoorAirQuality.self, ETXSteps.self] as [Any]
ETXTrendService.getTrend(startDate: startDate, endDate: endDate, classes: classes) {
            (trendResultSet: ETXTrendResultSet?, err: ETXError?) in
            // handle err
            
            // else use data
            let indoorAirQualityTrendResult: ETXClassTrendResultSet? = trendResultSet?.getClassSummary(ETXIndoorAirQuality.self)
            
            if let indoorAirQualityTrendResult = indoorAirQualityTrendResult {
                indoorAirQualityTrendResult.values?.forEach({
                    (aggregatedData: ETXAggregatable) in
                    print("Average indoor air quality for \(aggregatedData.date) is \(aggregatedData.value)")
                })
            }
            
        }
```

### Getting Trends Data For GenericDataObjects

In order to apply trends to Generics Data Objects, the platform will need to know the field that contains the `value` to be aggregated on, the field that holds `date` to fit within the timeframe and the `aggregation` type to be applied.

**The configuration will be applied to all Generic Data Objects in the list of classes.**

```swift
let dateFieldPropertyName = "date";
let valueFieldPropertyName = "value";
let aggregrationToApply = ETXTrendAggregation.avg
let gdoConfigForTrends: ETXGenericDataObjectConfiguration = ETXGenericDataObjectConfiguration(
    dateField: dateFieldPropertyName,
    trendField: valueFieldPropertyName,
    trend: aggregrationToApply
)

ETXTrendService.getTrend(trendTimeframe: ETXTrendTimeframe.TwoWeeks, classes: [ETXIndoorAirQuality.self], gdoConfig: gdoConfigForTrends) {
  (trendResultSet: ETXTrendResultSet?, err: ETXError?) in
  ...
};
```

## Adherence

Allows for reporting of adherence to the user's medications

```swift
ETXAdherenceService.getAdherence(trendTimeframe: ETXTrendTimeframe.TwoWeeks) {
  (adherenceResultSet: ETXAdherenceResultSet?, err: ETXError?) in
    // Do work
}
```

Specifying the medication to measure adherence for:

```swift
ETXAdherenceService.getAdherence(medicationId: "dulera_20", trendTimeframe: ETXTrendTimeframe.TwoWeeks){
  (adherenceResultSet: ETXAdherenceResultSet?, err: ETXError?) in
    // Do work
}
```

## Blobs

To store files on the platform use the `ETXBlob` class to define your data and save.

```swift
let userProfile: UserProfile = getUserProfile...

func uploadImage(imageData: UIImage) {
  guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {
    print("Could not get JPEG representation of UIImage")
    return
  }
  
  let blob = ETXBlob(fileData: imageData, fileName: "pic", mimeType: "image/png")
  //Save the blob
  blob.save {
   // attach it to the user profile for later retrieval
   userProfile.displayPhoto = blob.id
   // Update the profile with the ID to the blob
   userProfile.save {
     print("Profile photo updated")
   }
  }
}

```

Getting the blob later:

```swift
let userProfile: UserProfile = getUserProfile...
let urlToFile: URL = Blob.getUrl(userProfile. userProfile.displayPhoto)

```