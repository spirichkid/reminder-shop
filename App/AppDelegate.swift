//
//  AppDelegate.swift
//  reminder-shop
//
//  Created by Roman Spirichkin on 02/01/2019.
//  Copyright © 2019 perfectware. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		return true
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		guard let url = reminderURL else { return }
		UIApplication.shared.open(url)
	}
}

