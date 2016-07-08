//
//  EventsViewController.swift
//  iOS Demo
//
//  Created by Frank Schmitt on 4/27/16.
//  Copyright © 2016 Apptentive, Inc. All rights reserved.
//

import UIKit

private let EventsKey = "events"

class EventsViewController: UITableViewController {
	private var events = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = self.editButtonItem()

		updateEventList()

		NotificationCenter.default.addObserver(self, selector: #selector(EventsViewController.updateEventList), name: UserDefaults.didChangeNotification, object: nil)
    }

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Event", for: indexPath)

		cell.textLabel?.text = events[(indexPath as NSIndexPath).row]

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
			events.remove(at: (indexPath as NSIndexPath).row)
			saveEventList()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

	// MARK: Table view delegate

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if self.isEditing {
			if let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "StringNavigation") as? UINavigationController, let eventViewController = navigationController.viewControllers.first as? StringViewController {
				eventViewController.string = self.events[(indexPath as NSIndexPath).row]
				eventViewController.title = "Edit Event"
				self.present(navigationController, animated: true, completion: nil)
			}
		} else {
			Apptentive.sharedConnection().engage(events[(indexPath as NSIndexPath).row], from: self)
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}

	// MARK: - Segues

	override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
		if let navigationController = segue.destinationViewController as? UINavigationController, let eventViewController = navigationController.viewControllers.first {
			eventViewController.title = "New Event"
		}
	}

	@IBAction func returnToEventList(_ sender: UIStoryboardSegue) {
		if let name = (sender.sourceViewController as? StringViewController)?.string	{
			if let selectedIndex = (self.tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
				events[selectedIndex] = name
			} else {
				events.append(name)
			}

			events.sort()
			saveEventList()
			tableView.reloadSections(IndexSet(integer:0), with: .automatic)
		}
	}

	// MARK: - Private

	@objc private func updateEventList() {
		if let events = UserDefaults.standard.array(forKey: EventsKey) as? [String] {
			self.events = events
		}
	}

	private func saveEventList() {
		UserDefaults.standard.set(events, forKey: EventsKey)
	}
	
}
