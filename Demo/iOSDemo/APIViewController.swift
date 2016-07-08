//
//  APIViewController.swift
//  iOS Demo
//
//  Created by Frank Schmitt on 4/27/16.
//  Copyright © 2016 Apptentive, Inc. All rights reserved.
//

import UIKit

class APIViewController: UITableViewController {
	@IBOutlet var saveButtonItem: UIBarButtonItem!
	@IBOutlet var APIKeyField: UITextField!

	@IBAction func openDashboard() {
		UIApplication.shared().openURL(URL(string: "https://be.apptentive.com/apps/current/settings/api")!)
	}

	@IBAction func APIKeyChanged(_ sender: UITextField) {
		var result = false

		if let text = sender.text where text.lengthOfBytes(using: String.Encoding.utf8) == 64 && text.rangeOfCharacter(from: CharacterSet(charactersIn: "abcdef0123456789").inverted) == nil {
					result = true
		}

		self.saveButtonItem.isEnabled = result
	}

	@IBAction func save() {
		if let appDelegate = UIApplication.shared().delegate as? AppDelegate {
			appDelegate.connectWithAPIKey(APIKeyField.text!)
		}
		dismiss(animated: true, completion: nil)
	}
}
