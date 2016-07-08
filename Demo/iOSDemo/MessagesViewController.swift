//
//  MessagesViewController.swift
//  iOS Demo
//
//  Created by Frank Schmitt on 4/27/16.
//  Copyright © 2016 Apptentive, Inc. All rights reserved.
//

import UIKit

class MessagesViewController: UITableViewController {
	@IBOutlet var messageCenterCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()

		messageCenterCell.accessoryView = Apptentive.sharedConnection().unreadMessageCountAccessoryView(true)
    }

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		Apptentive .sharedConnection().presentMessageCenter(from: self)
	}
}
