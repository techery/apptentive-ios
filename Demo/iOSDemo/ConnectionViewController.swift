//
//  ConnectionViewController.swift
//  iOS Demo
//
//  Created by Frank Schmitt on 4/28/16.
//  Copyright © 2016 Apptentive, Inc. All rights reserved.
//

import UIKit
import MobileCoreServices

class ConnectionViewController: UITableViewController {
	@IBOutlet var APIKeyLabel: UILabel!
	@IBOutlet var conversationTokenLabel: UILabel!
	@IBOutlet var baseURLLabel: UILabel!
	@IBOutlet var appVersionLabel: UILabel!
	@IBOutlet var appBuildLabel: UILabel!
	@IBOutlet var SDKVersionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

		if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
			appVersionLabel.text = appVersion
		}

		if let appBuild = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
			appBuildLabel.text = appBuild
		}

		SDKVersionLabel.text = kApptentiveVersionString

		refresh()

		NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.ApptentiveConversationCreated, object: nil)
	}

	override func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
		return true
	}

	override func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: AnyObject?) -> Bool {
		return action == #selector(NSObject.copy(_:))
	}

	override func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: AnyObject?) {
		if action == #selector(NSObject.copy(_:)) {
			if let cell = tableView.cellForRow(at: indexPath), let text = cell.detailTextLabel?.text {
				UIPasteboard.general().setValue(text, forPasteboardType: kUTTypeUTF8PlainText as String)
			}
		}
	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	@objc private func refresh() {
		APIKeyLabel.text = Apptentive.sharedConnection().apiKey
		conversationTokenLabel.text = Apptentive.sharedConnection().conversationToken
		baseURLLabel.text = Apptentive.sharedConnection().baseURL?.absoluteString
	}
}
