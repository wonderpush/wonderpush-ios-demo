//
//  AppDelegate.swift
//  WonderPushDemo
//
//  Created by Olivier Favre on 27/04/17.
//  Copyright © 2017 WonderPush. All rights reserved.
//

import UIKit
import WonderPush

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var locationManager: CLLocationManager = CLLocationManager()

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        WonderPush.setLogging(true)
        WonderPush.setClientId("7524c8a317c1794c0b23895dce3a3314d6a24105", secret: "b43a2d0fbdb54d24332b4d70736954eab5d24d29012b18ef6d214ff0f51e7901")
        WonderPush.setupDelegate(for: application)
        WonderPush.setupDelegateForUserNotificationCenter()
        WonderPush.putInstallationCustomProperties(["int_foo": arc4random()])
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // TODO add registered callbacks

        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let geolocation = UserDefaults.standard.bool(forKey: "geolocation")
        if (geolocation) {
            self.locationManager.startUpdatingLocation()
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("application: open:\(url) options:\(options)")
        if let window = window {
            let alert = UIAlertController(title: "Deep link", message: url.absoluteString, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            alert.show(window.rootViewController!, sender: nil)
        }
        return true
    }

}

