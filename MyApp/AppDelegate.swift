//
//  AppDelegate.swift
//  MyApp
//
//  Created by Zac White on 7/31/17.
//  Copyright © 2017 Velos Mobile LLC. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        Fabric.with([Crashlytics.self])

        return true
    }
}
