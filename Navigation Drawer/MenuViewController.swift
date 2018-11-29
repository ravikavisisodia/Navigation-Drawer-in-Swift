//
//  MenuViewController.swift
//  Navigation Drawer
//
//  Created by Ravi Sisodia on 29/11/18.
//  Copyright © 2018 CultureAlley. All rights reserved.
//

import UIKit

class GroupItem {
	let id, title: String
	init(id: String, title: String) {
		self.id = id
		self.title = title
	}
}

class Group {
	let title: String, items: [GroupItem]
	init(title: String, items: [GroupItem]) {
		self.title = title
		self.items = items
	}
}

class MenuViewController: ViewController {

	fileprivate let data = [
		Group(title: "Group 1", items: [
			GroupItem(id: "1", title: "Item 1"),
			GroupItem(id: "2", title: "Item 2"),
			GroupItem(id: "3", title: "Item 3")
		]),
		Group(title: "Group 2", items: [
			GroupItem(id: "4", title: "Item 4"),
			GroupItem(id: "5", title: "Item 5")
		]),
		Group(title: "Group 3", items: [
			GroupItem(id: "6", title: "Item 6"),
			GroupItem(id: "7", title: "Item 7"),
			GroupItem(id: "8", title: "Item 8"),
			GroupItem(id: "9", title: "Item 9"),
			GroupItem(id: "10", title: "Item 10")
		]),
		Group(title: "Group 4", items: [
			GroupItem(id: "11", title: "Item 11"),
			GroupItem(id: "12", title: "Item 12"),
			GroupItem(id: "13", title: "Item 13")
		]),
		Group(title: "Group 5", items: [
			GroupItem(id: "14", title: "Item 14"),
			GroupItem(id: "15", title: "Item 15")
		])
	]
	@IBOutlet var tableView: UITableView!
	
}

extension MenuViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return self.data.count
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.data[section].items.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return self.data[section].title
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "menuItemCell", for: indexPath)
		cell.textLabel?.text = self.data[indexPath.section].items[indexPath.row].title
		return cell
	}
}

extension MenuViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return indexPath
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		print("MenuViewController: didSelectRowAt: \(indexPath)")
	}
}
