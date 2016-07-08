//
//  DataViewController.swift
//  iOS Demo
//
//  Created by Frank Schmitt on 4/27/16.
//  Copyright © 2016 Apptentive, Inc. All rights reserved.
//

import UIKit

class DataViewController: UITableViewController {
	@IBOutlet var modeControl: UISegmentedControl!
	let dataSources = [PersonDataSource(), DeviceDataSource()]

	override func setEditing(_ editing: Bool, animated: Bool) {
		dataSources.forEach { $0.editing = editing }

		let numberOfRows = self.tableView.numberOfRows(inSection: 1)
		var indexPaths = [IndexPath]()
		if editing {
			for row in numberOfRows..<(numberOfRows + 3) {
				indexPaths.append(IndexPath(row: row, section: 1))
			}
			self.tableView.insertRows(at: indexPaths, with: .top)
		} else {
			for row in (numberOfRows - 3)..<numberOfRows {
				indexPaths.append(IndexPath(row: row, section: 1))
			}
			self.tableView.deleteRows(at: indexPaths, with: .top)
		}

		super.setEditing(editing, animated: animated)
	}

    override func viewDidLoad() {
        super.viewDidLoad()

		self.navigationItem.titleView = modeControl

		self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		updateMode(modeControl)
	}

	override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
		if (indexPath as NSIndexPath).section == 1 {
			if (indexPath as NSIndexPath).row >= tableView.numberOfRows(inSection: 1) - 3 {
				return .insert
			} else {
				return .delete
			}
		}

		return .none
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if let dataSource = tableView.dataSource as? DataSource where dataSource == dataSources[0] && (indexPath as NSIndexPath).section == 0 && self.isEditing {
			if let navigationController = self.storyboard?.instantiateViewController(withIdentifier: "NameEmailNavigation") as? UINavigationController, let stringViewController = navigationController.viewControllers.first as? StringViewController {
				stringViewController.title = (indexPath as NSIndexPath).row == 0 ? "Edit Name" : "Edit Email"
				stringViewController.string = (indexPath as NSIndexPath).row == 0 ? Apptentive.sharedConnection().personName : Apptentive.sharedConnection().personEmailAddress
				self.present(navigationController, animated: true, completion: nil)
			}
		}
	}

	@IBAction func updateMode(_ sender: UISegmentedControl) {
		let dataSource = dataSources[sender.selectedSegmentIndex]

		dataSource.refresh()
		self.tableView.dataSource = dataSource;
		self.tableView.reloadData()
	}

	@IBAction func returnToDataList(_ sender: UIStoryboardSegue) {
		if let value = (sender.sourceViewController as? StringViewController)?.string {
			if let selectedIndex = (self.tableView.indexPathForSelectedRow as NSIndexPath?)?.row {
				if selectedIndex == 0 {
					Apptentive.sharedConnection().personName = value
				} else {
					Apptentive.sharedConnection().personEmailAddress = value
				}
			}

			tableView.reloadSections(IndexSet(integer:0), with: .automatic)
		}
	}

	func addCustomData(_ index: Int) {
		print("Adding type with index \(index)")
	}
}

class DataSource: NSObject, UITableViewDataSource {
	var editing = false

	override init() {
		super.init()
		self.refresh()
	}

	func numberOfSections(in tableView: UITableView) -> Int {
		return 2
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		return tableView.dequeueReusableCell(withIdentifier: "Datum", for: indexPath)
	}

	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if section == 0 {
			return "Standard Data"
		} else {
			return "Custom Data"
		}
	}

	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return (indexPath as NSIndexPath).section == 1
	}

	func refresh() {
	}

	// TODO: convert to enum?
	func labelForAdding(_ index: Int) -> String {
		switch index {
		case 0:
			return "Add String"
		case 1:
			return "Add Number"
		default:
			return "Add Boolean"
		}
	}

	func reuseIdentifierForAdding(_ index: Int) -> String {
		switch index {
		case 0:
			return "String"
		case 1:
			return "Number"
		default:
			return "Boolean"
		}
	}
}

class PersonDataSource: DataSource {
	var customKeys = [String]()
	var customData = [String : NSObject]()

	override func refresh() {
		if let customData = (Apptentive.sharedConnection().customPersonData as NSDictionary) as? [String : NSObject] {
			self.customData = customData
			self.customKeys = customData.keys.sorted { $0 < $1 }
		}
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return 2
		} else {
			return self.customKeys.count + (self.editing ? 3 : 0)
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell

		if (indexPath as NSIndexPath).section == 0 || (indexPath as NSIndexPath).row < self.customKeys.count {
			cell = tableView.dequeueReusableCell(withIdentifier: "Datum", for: indexPath)
			let key: String
			let value: String?

			if (indexPath as NSIndexPath).section == 0 {
				if (indexPath as NSIndexPath).row == 0 {
					key = "Name"
					value = Apptentive.sharedConnection().personName
				} else  {
					key = "Email"
					value = Apptentive.sharedConnection().personEmailAddress
				}
			} else {
				key = self.customKeys[(indexPath as NSIndexPath).row]
				value = self.customData[key]?.description
			}

			cell.textLabel?.text = key
			cell.detailTextLabel?.text = value
		} else {
			cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifierForAdding((indexPath as NSIndexPath).row - self.customKeys.count), for: indexPath)
		}

		return cell
	}

	func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath) {
		if (indexPath as NSIndexPath).section == 0 {
			return
		} else if editingStyle == .delete {
			Apptentive.sharedConnection().removeCustomPersonData(withKey: self.customKeys[(indexPath as NSIndexPath).row])
			self.refresh()
			tableView.deleteRows(at: [indexPath], with: .automatic)
		} else if editingStyle == .insert {
			if let cell = tableView.cellForRow(at: indexPath) as? CustomDataCell, let key = cell.keyField.text {
				switch self.reuseIdentifierForAdding((indexPath as NSIndexPath).row - self.customKeys.count) {
				case "String":
					if let textField = cell.valueControl as? UITextField, string = textField.text {
						Apptentive.sharedConnection().addCustomPersonDataString(string, withKey: key)
						textField.text = nil
					}
				case "Number":
					if let textField = cell.valueControl as? UITextField, numberString = textField.text, number = NumberFormatter().number(from: numberString) {
						Apptentive.sharedConnection().addCustomPersonDataNumber(number, withKey: key)
						textField.text = nil
					}
				case "Boolean":
					if let switchControl = cell.valueControl as? UISwitch {
						Apptentive.sharedConnection().addCustomPersonDataBool(switchControl.isOn, withKey: key)
						switchControl.isOn = true
					}
				default:
					break;
				}
				tableView.deselectRow(at: indexPath, animated: true)
				self.refresh()
				tableView.reloadSections(IndexSet(integer:1), with: .automatic)
				cell.keyField.text = nil
			}
		}
	}
}

class DeviceDataSource: DataSource {
	var deviceKeys = [String]()
	var deviceData = [String : AnyObject]()

	var customDeviceKeys = [String]()
	var customDeviceData = [String : NSObject]()

	override func refresh() {
		self.deviceData = Apptentive.sharedConnection().deviceInfo
		self.deviceKeys = self.deviceData.keys.sorted { $0 < $1 }

		if let customDataKeyIndex = self.deviceKeys.index(of: "custom_data") {
			self.deviceKeys.remove(at: customDataKeyIndex)
		}

		if let customDeviceData = (Apptentive.sharedConnection().customDeviceData as NSDictionary) as? [String : NSObject] {
			self.customDeviceData = customDeviceData
			self.customDeviceKeys = customDeviceData.keys.sorted { $0 < $1 }
		}
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		if section == 0 {
			return self.deviceKeys.count
		} else {
			return self.customDeviceKeys.count + (self.editing ? 3 : 0)
		}
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell

		if (indexPath as NSIndexPath).section == 0 || (indexPath as NSIndexPath).row < self.customDeviceKeys.count {
			cell = tableView.dequeueReusableCell(withIdentifier: "Datum", for: indexPath)
			let key: String
			let value: String?

			if (indexPath as NSIndexPath).section == 0 {
				key = self.deviceKeys[(indexPath as NSIndexPath).row]
				value = self.deviceData[key]?.description
			} else {
				key = self.customDeviceKeys[(indexPath as NSIndexPath).row]
				value = self.customDeviceData[key]?.description
			}

			cell.textLabel?.text = key
			cell.detailTextLabel?.text = value
			cell.selectionStyle = (indexPath as NSIndexPath).section == 0 ? .none : .default
		} else {
			cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentifierForAdding((indexPath as NSIndexPath).row - self.customDeviceKeys.count), for: indexPath)
		}

		return cell
	}

	func tableView(_ tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: IndexPath) {
		if (indexPath as NSIndexPath).section == 0 {
			return
		} else if editingStyle == .delete {
			Apptentive.sharedConnection().removeCustomDeviceData(withKey: self.customDeviceKeys[(indexPath as NSIndexPath).row])
			self.refresh()
			tableView.deleteRows(at: [indexPath], with: .automatic)
		} else if editingStyle == .insert {
			if let cell = tableView.cellForRow(at: indexPath) as? CustomDataCell, let key = cell.keyField.text {
				switch self.reuseIdentifierForAdding((indexPath as NSIndexPath).row - self.customDeviceKeys.count) {
				case "String":
					if let textField = cell.valueControl as? UITextField, string = textField.text {
						Apptentive.sharedConnection().addCustomDeviceDataString(string, withKey: key)
						textField.text = nil
					}
				case "Number":
					if let textField = cell.valueControl as? UITextField, numberString = textField.text, number = NumberFormatter().number(from: numberString) {
						Apptentive.sharedConnection().addCustomDeviceDataNumber(number, withKey: key)
						textField.text = nil
					}
				case "Boolean":
					if let switchControl = cell.valueControl as? UISwitch {
						Apptentive.sharedConnection().addCustomDeviceDataBool(switchControl.isOn, withKey: key)
						switchControl.isOn = true
					}
				default:
					break;
				}
				tableView.deselectRow(at: indexPath, animated: true)
				self.refresh()
				tableView.reloadSections(IndexSet(integer:1), with: .automatic)
				cell.keyField.text = nil
			}
		}
	}
}
