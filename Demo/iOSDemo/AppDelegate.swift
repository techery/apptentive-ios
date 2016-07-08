//
//  AppDelegate.swift
//  iOS Demo
//
//  Created by Frank Schmitt on 4/26/16.
//  Copyright © 2016 Apptentive, Inc. All rights reserved.
//

import UIKit

private let APIKeyKey = "APIKey"
private let AppIDKey = "appID"
private let baseURLKey = "baseURL"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		self.registerDefaults()

		UITabBar.appearance().tintColor = UIColor.apptentiveRed()

		if let APIKey = UserDefaults.standard.string(forKey: APIKeyKey) {
			self.connectWithAPIKey(APIKey)
		}

		return true
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		if UserDefaults.standard.string(forKey: APIKeyKey) == nil {
			if let rootViewController = self.window?.rootViewController  {
				rootViewController.performSegue(withIdentifier: "ShowAPI", sender: self)
			}
		}
	}

	func connectWithAPIKey(_ APIKey: String) {
		let apptentiveBaseURL: URL
		if let baseURLString = UserDefaults.standard.string(forKey: baseURLKey), baseURL = URL(string: baseURLString) {
			apptentiveBaseURL = baseURL
		} else {
			apptentiveBaseURL = URL(string: "https://api.apptentive.com")!
		}

		Apptentive.sharedConnection().setAPIKey(APIKey, baseURL: apptentiveBaseURL)
		UserDefaults.standard.set(APIKey, forKey: APIKeyKey)
	}

	private func registerDefaults() {
		if let defaultDefaultsURL = Bundle.main.urlForResource("Defaults", withExtension: "plist"), defaultDefaults = NSDictionary(contentsOf:defaultDefaultsURL) as? [String : AnyObject] {
			UserDefaults.standard.register(defaultDefaults)
		}
	}
}

extension UIColor {
	class func apptentiveRed() -> UIColor {
		return UIColor(red: 237/255, green: 65/255, blue: 76/255, alpha: 1)
	}
}


