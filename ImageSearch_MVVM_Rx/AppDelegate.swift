//
//  AppDelegate.swift
//  ImageSearch_MVVM_Rx
//
//  Created by Hyoungsu Ham on 2020/06/02.
//  Copyright © 2020 Ham-Dev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let rootVC: MainViewController = MainViewController()
        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = rootVC
        return true
    }
}

