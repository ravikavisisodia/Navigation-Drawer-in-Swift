//
//  NavigationDrawerController.swift
//  Navigation Drawer
//
//  Created by Ravi Sisodia on 29/11/18.
//  Copyright © 2018 CultureAlley. All rights reserved.
//

import UIKit

enum DrawerPresentationDirection {
	case left
	case right
}

class DrawerContainer: UIView {
	
}

class NavigationDrawerController: NSObject {
	
	private var thresholdSpeedForSwipe: CGFloat = 700
	private var actualDirection: DrawerPresentationDirection {
		let attribute = self.presentingController.view.semanticContentAttribute
		let rtl = UIView.userInterfaceLayoutDirection(for: attribute) == .rightToLeft
		return rtl ? (self.direction == .left ? .right : .left) : self.direction
	}
	private var drawerContainer: DrawerContainer {
		let view = DrawerContainer()
		view.backgroundColor = .clear
		view.frame = self.presentingController.view.bounds
		return view
	}
	
	private var drawerNavigationDelegate: UINavigationControllerDelegate?
	let drawer: UIViewController, presentingController: UIViewController
	let direction: DrawerPresentationDirection
	init(drawer: UIViewController, presentingController: UIViewController, direction: DrawerPresentationDirection) {
		self.drawer = drawer
		self.presentingController = presentingController
		self.direction = direction
	}
	
	func presentDrawer() {
		let drawerContainer = self.drawerContainer
		self.presentingController.view.addSubview(drawerContainer)
		
		let f = self.presentingController.view.frame, w = min(UI_USER_INTERFACE_IDIOM() == .pad ? 420 : 320, f.width - 64)
		self.drawer.view.frame = CGRect(x: self.actualDirection == .left ? -w : (f.width + w), y: 0, width: w, height: f.height)
		
		self.presentingController.addChild(self.drawer)
		drawerContainer.addSubview(self.drawer.view)
		self.drawer.beginAppearanceTransition(true, animated: true)
		self.drawer.endAppearanceTransition()
		self.drawer.didMove(toParent: self.presentingController)
		self.drawer.view.layoutIfNeeded()
		
		UIView.animate(withDuration: 0.4, animations: {
			drawerContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
			self.drawer.view.frame = CGRect(x: self.actualDirection == .left ? 0 : (f.width - w), y: 0, width: w, height: f.height)
		}) { finished in
			drawerContainer.isUserInteractionEnabled = true
			let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.userDidPanDrawerContainer(_:)))
			panGesture.maximumNumberOfTouches = 1
			let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.userDidClickDrawerContainer(_:)))
			tapGesture.delegate = self
			drawerContainer.gestureRecognizers = [ tapGesture, panGesture ]
			
			self.drawerNavigationDelegate = (self.drawer as? UINavigationController)?.delegate
			(self.drawer as? UINavigationController)?.delegate = self
		}
	}
	
	func dismissDrawer() {
		guard let drawerContainer = self.drawer.view.superview as? DrawerContainer else {
			return
		}
		
		self.dismissDrawer(in: drawerContainer)
	}
	
	private func dismissDrawer(in drawerContainer: DrawerContainer) {
		let f = self.presentingController.view.frame, w = min(UI_USER_INTERFACE_IDIOM() == .pad ? 420 : 320, f.width - 64)
		let df = self.drawer.view.frame, tf = Double((self.actualDirection == .left ? (w + df.minX) : (f.width - df.minX))/w)
		self.drawer.willMove(toParent: nil)
		self.drawer.beginAppearanceTransition(false, animated: true)
		UIView.animate(withDuration: 0.4*tf, animations: {
			drawerContainer.backgroundColor = .clear
			self.drawer.view.frame = CGRect(x: self.actualDirection == .left ? -w : (f.width + w), y: 0, width: w, height: f.height)
		}) { finished in
			self.drawer.endAppearanceTransition()
			self.drawer.view.removeFromSuperview()
			self.drawer.removeFromParent()
			
			drawerContainer.removeFromSuperview()
			(self.drawer as? UINavigationController)?.delegate = self.drawerNavigationDelegate
		}
	}
}

extension NavigationDrawerController: UINavigationControllerDelegate {
	func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
		if viewController == navigationController.viewControllers.first {
			let f = self.presentingController.view.frame, w = min(UI_USER_INTERFACE_IDIOM() == .pad ? 420 : 320, f.width - 64)
			self.drawerContainer.clipsToBounds = self.drawer.view.clipsToBounds
			self.drawer.view.clipsToBounds = true
			UIView.animate(withDuration: 0.1, animations: {
				self.drawer.view.frame = CGRect(x: self.actualDirection == .left ? 0 : (f.width - w), y: 0, width: w, height: f.height)
			})
		} else {
			UIView.animate(withDuration: 0.2, animations: {
				self.drawer.view.frame = self.presentingController.view.bounds
			})
		}
		self.drawerNavigationDelegate?.navigationController?(navigationController, willShow: viewController, animated: animated)
	}
	
	func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
		self.drawerNavigationDelegate?.navigationController?(navigationController, didShow: viewController, animated: animated)
		UIView.animate(withDuration: 0.1, animations: {}) { _ in
			self.drawer.view.clipsToBounds = self.drawerContainer.clipsToBounds
			self.drawerContainer.clipsToBounds = false
		}
	}
	
	func navigationControllerSupportedInterfaceOrientations(_ navigationController: UINavigationController) -> UIInterfaceOrientationMask {
		return self.drawerNavigationDelegate?.navigationControllerSupportedInterfaceOrientations?(navigationController) ?? .all
	}
	
	func navigationControllerPreferredInterfaceOrientationForPresentation(_ navigationController: UINavigationController) -> UIInterfaceOrientation {
		return self.drawerNavigationDelegate?.navigationControllerPreferredInterfaceOrientationForPresentation?(navigationController) ?? .unknown
	}
	
	func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
		return self.drawerNavigationDelegate?.navigationController?(navigationController, interactionControllerFor: animationController)
	}
	
	func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return self.drawerNavigationDelegate?.navigationController?(navigationController, animationControllerFor: operation, from: fromVC, to: toVC)
	}
}

extension NavigationDrawerController: UIGestureRecognizerDelegate {
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		return gestureRecognizer.view == touch.view
	}
}

extension NavigationDrawerController {
	@objc private func userDidClickDrawerContainer(_ tapGesture: UITapGestureRecognizer) {
		guard let drawerContainer = tapGesture.view as? DrawerContainer else {
			return
		}
		self.dismissDrawer(in: drawerContainer)
	}
	
	@objc private func userDidPanDrawerContainer(_ panGesture: UIPanGestureRecognizer) {
		guard let drawerContainer = panGesture.view as? DrawerContainer else {
			return
		}
		let t = panGesture.translation(in: drawerContainer)
		switch panGesture.state {
		case .began: break
		case .changed: self.touchTranslated(by: t)
		default: self.touchEnded(with: t, and: panGesture.velocity(in: drawerContainer))
		}
	}
	
	private func reset(in drawerContainer: UIView) {
		let f = self.presentingController.view.frame, w = min(UI_USER_INTERFACE_IDIOM() == .pad ? 420 : 320, f.width - 64)
		let df = self.drawer.view.frame, tf = Double((self.actualDirection == .left ? -df.minX : (w - f.width + df.minX))/w)
		UIView.animate(withDuration: 0.4*tf) {
			drawerContainer.backgroundColor = UIColor.black.withAlphaComponent(0.5)
			self.drawer.view.frame = CGRect(x: self.actualDirection == .left ? 0 : (f.width - w), y: 0, width: w, height: f.height)
		}
	}
	
	private func touchTranslated(by translation: CGPoint) {
		guard (self.actualDirection == .left && translation.x < 0) || (self.actualDirection == .right && translation.x > 0) else {
			return
		}
		
		let f = self.presentingController.view.frame, w = min(UI_USER_INTERFACE_IDIOM() == .pad ? 420 : 320, f.width - 64)
		self.drawer.view.frame = CGRect(x: (self.actualDirection == .left ? 0 : (f.width - w)) + translation.x, y: 0, width: w, height: f.height)
	}
	
	private func touchEnded(with translation: CGPoint, and velocity: CGPoint) {
		guard let drawerContainer = self.drawer.view.superview as? DrawerContainer else {
			return
		}
		let f = self.presentingController.view.frame, w = min(UI_USER_INTERFACE_IDIOM() == .pad ? 420 : 320, f.width - 64)
		
		if self.actualDirection == .left {
			if velocity.x <= -1*self.thresholdSpeedForSwipe {
				return self.dismissDrawer(in: drawerContainer)
			} else if translation.x <= -1*w/2 {
				return self.dismissDrawer(in: drawerContainer)
			}
		} else {
			if velocity.x >= self.thresholdSpeedForSwipe {
				return self.dismissDrawer(in: drawerContainer)
			} else if translation.x >= w/2 {
				return self.dismissDrawer(in: drawerContainer)
			}
		}
		self.reset(in: drawerContainer)
	}
}
