//
//  InteractionsViewController.swift
//  iOS Demo
//
//  Created by Frank Schmitt on 4/27/16.
//  Copyright © 2016 Apptentive, Inc. All rights reserved.
//

import UIKit

class InteractionsViewController: UITableViewController {
	@IBOutlet var exportButtonItem: UIBarButtonItem!
	var interactionCount = 0
	var interactionNames = [String]()
	var interactionTypes = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

		NotificationCenter.default.addObserver(self, selector: #selector(updateInteractionList), name: NSNotification.Name.ApptentiveInteractionsDidUpdate, object: nil)
    }

	deinit	 {
		NotificationCenter.default.removeObserver(self)
	}

	@IBAction func export(_ sender: AnyObject) {
		if let JSON = Apptentive.sharedConnection().manifestJSON {
			let activityViewController = UIActivityViewController(activityItems: [JSON], applicationActivities: nil)
			self.present(activityViewController, animated: true, completion: nil)
		} else {
			let title = "Manifest JSON Not Available"
			let message = "This could be because interactions haven't downloaded yet on this launch, or because the app is not running in the Debug build configuration."

			if #available(iOS 8.0, *) {
				let alertController = UIAlertController(title: title , message: message, preferredStyle: .alert)
				alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

				self.present(alertController, animated: true, completion: nil)
			} else {
				UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK").show()
			}
		}
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Apptentive.sharedConnection().engagementInteractions().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Interaction", for: indexPath)

        cell.textLabel?.text = Apptentive.sharedConnection().engagementInteractionName(at: (indexPath as NSIndexPath).row)
		cell.detailTextLabel?.text = Apptentive.sharedConnection().engagementInteractionType(at: (indexPath as NSIndexPath).row)

        return cell
    }

	// MARK: Table view delegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		Apptentive.sharedConnection().presentInteraction(at: (indexPath as NSIndexPath).row, from: self)
		tableView.deselectRow(at: indexPath, animated: true)
	}

	// MARK: - Private

	@objc private func updateInteractionList() {
		self.exportButtonItem.isEnabled = true
		tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
	}
}
