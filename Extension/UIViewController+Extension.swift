//
//  UIViewController+Extension.swift
//  reminder-shop
//
//  Created by Roman Spirichkin on 02/01/2019.
//  Copyright © 2019 perfectware. All rights reserved.
//

import UIKit

extension UIViewController {
	var navBarSeparator: UIImageView? {
		return navigationController?.navigationBar.subviews
			.flatMap { $0.subviews }
			.compactMap { $0 as? UIImageView }
			.filter { $0.bounds.size.width == self.navigationController?.navigationBar.bounds.size.width }
			.filter { $0.bounds.size.height <= 2 }
			.first
	}
	
	@discardableResult
	func setupBackButtonItem() -> UIBarButtonItem {
		let item = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(popViewController))
		navigationItem.setLeftBarButton(item, animated: false)
		return item
	}
	
	@objc
	private func popViewController(sender: UIBarButtonItem) {
		guard sender === navigationItem.leftBarButtonItem else { return }
		guard let nc = navigationController, navigationController?.viewControllers.last == self else { return }
		nc.popViewController(animated: true)
	}
}
