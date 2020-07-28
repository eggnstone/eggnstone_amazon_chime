import Flutter
import UIKit

public class SwiftEggnstoneAmazonChimePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "eggnstone_amazon_chime", binaryMessenger: registrar.messenger())
    let instance = SwiftEggnstoneAmazonChimePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
