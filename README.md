## 🚀 Introduction

# Food Finder
<p>Hungry? No Need! Our mobile app leverages Google Cloud, Firebase, and Flutter to fight hunger! We map nearby free food locations like pantries, shelters, and community kitchens, empowering users to find immediate meals and connecting them with valuable resources. Join us to build a hunger-free future, one tap at a time!</p>

## 🛠️ Technologies Used

The Hunger App is built using the following technologies:

- Flutter SDK
- Dart programming language
- Firebase 
- Flutter packages for Google Map and other Functionalities



## ⚙️ Getting Started

To run this project locally, follow these steps:

1. Clone this repository to your local machine using:
```
git clone https://github.com/vaibhav-sutariya/hungry.git
```

2. Open the project in your preferred Flutter development environment.

3. Get an API key at <https://cloud.google.com/maps-platform/>.

4. Paste an API Key according to below instruction.

### Android

Specify your API key in the application manifest `android/app/src/main/AndroidManifest.xml`:

```xml
<manifest ...
  <application ...
    <meta-data android:name="com.google.android.geo.API_KEY"
               android:value="YOUR KEY HERE"/>
```

### iOS

Specify your API key in the application delegate `ios/Runner/AppDelegate.m`:

```objectivec
#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GMSServices provideAPIKey:@"YOUR KEY HERE"];
  [GeneratedPluginRegistrant registerWithRegistry:self];
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
```

Or in your swift code, specify your API key in the application delegate `ios/Runner/AppDelegate.swift`:

```swift
import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("YOUR KEY HERE")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
```
Opt-in to the embedded views preview by adding a boolean property to the app's `Info.plist` file
with the key `io.flutter.embedded_views_preview` and the value `YES`.

5. Run the Flutter app using the following command:

```
flutter run
```


