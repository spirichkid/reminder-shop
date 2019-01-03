//
//  UITableViewCell+Extension.swift
//  reminder-shop
//
//  Created by Roman Spirichkin on 02/01/2019.
//  Copyright © 2019 perfectware. All rights reserved.
//

import UIKit

extension UITableViewCell {
	static var reuseIdentifier: String {
		return className
	}
	
	static func register(in tableView: UITableView, isNib: Bool = false) {
		guard isNib else {
			return tableView.register(self, forCellReuseIdentifier: reuseIdentifier)
		}
		let nib = UINib(nibName: className, bundle: nil)
		tableView.register(nib, forCellReuseIdentifier: reuseIdentifier)
	}
}
