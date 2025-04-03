import Flutter
import UIKit
import GoogleMaps
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKey("AIzaSyABRQIbm3Dl4x8TKq_6Ht3PaNllH_8yuwo")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
