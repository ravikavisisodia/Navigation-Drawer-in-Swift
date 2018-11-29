//
//  SettingsViewController.swift
//  Navigation Drawer
//
//  Created by Ravi Sisodia on 29/11/18.
//  Copyright © 2018 CultureAlley. All rights reserved.
//

import UIKit

class SettingsNavigationController: UINavigationController {
	weak var navigationDrawerController: NavigationDrawerController!
}

class SettingsViewController: ViewController {
	
	fileprivate let data = [
		Group(title: "Localization", items: [
			GroupItem(id: "ar", title: "Arabic"),
			GroupItem(id: "en", title: "English")
		])
	]
	@IBOutlet var tableView: UITableView!
}

extension SettingsViewController: UITableViewDataSource {
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
		let cell = self.tableView.dequeueReusableCell(withIdentifier: "settingsItemCell", for: indexPath)
		cell.textLabel?.text = self.data[indexPath.section].items[indexPath.row].title
		return cell
	}
}

extension SettingsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
		return indexPath
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let item = self.data[indexPath.section].items[indexPath.row]
		UserDefaults.standard.set([item.id], forKey: "AppleLanguages")
		UserDefaults.standard.synchronize()
		
		let alert = UIAlertController(title: "Localization changed to \(item.title)", message: "Remove app from 'recent app list' and restart again to reflect the localization.", preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: "OK!", style: .default, handler: { _ in
			guard let navController = self.navigationController as? SettingsNavigationController else {
				return
			}
			navController.navigationDrawerController?.dismissDrawer()
		}))
		self.present(alert, animated: true, completion: nil)
	}
}
