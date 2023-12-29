import UIKit
import Flutter
import FirebaseCore
import YandexMapsMobile


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    //Push Notifications  
    // UNUserNotificationCenter.current().delegate = self
    // let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    // UNUserNotificationCenter.current().requestAuthorization(
    //   options: authOptions,
    //   completionHandler: { _, _ in }
    // )
    // application.registerForRemoteNotifications()
    //Yandex MapKit  
    YMKMapKit.setLocale("YOUR_LOCALE") // Your preferred language. Not required, defaults to system language
    YMKMapKit.setApiKey("1d464ce6-e63e-414c-b06d-a4d9a739ae14") // Your generated API key
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  } 
}
