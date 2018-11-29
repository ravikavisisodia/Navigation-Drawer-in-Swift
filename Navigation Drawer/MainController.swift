//
//  MainController.swift
//  Navigation Drawer
//
//  Created by Ravi Sisodia on 29/11/18.
//  Copyright © 2018 CultureAlley. All rights reserved.
//

import UIKit

class MainController: ViewController {

	var drawerController: NavigationDrawerController!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		if UIView.userInterfaceLayoutDirection(for: self.view.semanticContentAttribute) == .rightToLeft {
			self.title = "RTL"
		} else {
			self.title = "LTR"
		}
		
		self.view.gestureRecognizers = [
			UITapGestureRecognizer(target: self, action: #selector(self.showDrawer(_:)))
		]
		
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "baseline_menu_black_24pt"),
																style: .plain,
																target: self,
																action: #selector(self.userDidClickMenuButton))
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "baseline_settings_black_24pt"),
																 style: .plain,
																 target: self,
																 action: #selector(self.userDidClickSettingsButton))
	}
	
	@objc private func userDidClickMenuButton() {
		guard let navigationController = self.navigationController else {
			return
		}
		let drawer = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MenuViewController")
		self.drawerController = NavigationDrawerController(drawer: drawer, presentingController: navigationController, direction: .left)
		self.drawerController.presentDrawer()
	}
	
	@objc private func userDidClickSettingsButton() {
		guard let navigationController = self.navigationController else {
			return
		}
		let s = UIStoryboard(name: "Main", bundle: nil)
		let drawer = s.instantiateViewController(withIdentifier: "SettingsNavigationController") as! SettingsNavigationController
		self.drawerController = NavigationDrawerController(drawer: drawer, presentingController: navigationController, direction: .right)
		drawer.navigationDrawerController = self.drawerController
		self.drawerController.presentDrawer()
	}
	
	@objc private func showDrawer(_ tapGesture: UITapGestureRecognizer) {
		let rtl = UIView.userInterfaceLayoutDirection(for: self.view.semanticContentAttribute) == .rightToLeft
		var r = tapGesture.location(in: tapGesture.view).x > self.view.frame.width/2
		r = rtl ? !r : r
		let s = UIStoryboard(name: "Main", bundle: nil)
		if r {
			let drawer = s.instantiateViewController(withIdentifier: "SettingsNavigationController") as! SettingsNavigationController
			self.drawerController = NavigationDrawerController(drawer: drawer, presentingController: self, direction: .right)
			drawer.navigationDrawerController = self.drawerController
		} else {
			let drawer = s.instantiateViewController(withIdentifier: "MenuViewController")
			self.drawerController = NavigationDrawerController(drawer: drawer, presentingController: self, direction: r ? .right : .left)
		}
		self.drawerController.presentDrawer()
	}
}

class ViewController: UIViewController {
	public var nameOfClass: String {
		return NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print("ViewController: viewDidLoad: \(self.nameOfClass)")
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		print("ViewController: viewWillAppear: \(self.nameOfClass)")
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		print("ViewController: viewDidAppear: \(self.nameOfClass)")
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		
		print("ViewController: viewWillDisappear: \(self.nameOfClass)")
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		print("ViewController: viewDidDisappear: \(self.nameOfClass)")
	}
}
