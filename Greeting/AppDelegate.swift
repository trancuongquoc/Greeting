//
//  AppDelegate.swift
//  Greeting
//
//  Created by Quoc Cuong on 12/26/19.
//  Copyright © 2019 Tran Cuong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

//    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.makeKeyAndVisible()
//
//        window?.rootViewController = UINavigationController(rootViewController: ViewController())

        ViewComponent.shareInstance.start()
        return true
    }
}

