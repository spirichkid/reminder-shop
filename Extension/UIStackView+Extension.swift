//
//  UIStackView+Extension.swift
//  reminder-shop
//
//  Created by Roman Spirichkin on 02/01/2019.
//  Copyright © 2019 perfectware. All rights reserved.
//

import UIKit

extension UIStackView {
	@objc convenience init(axis: NSLayoutConstraint.Axis = .vertical, spacing: CGFloat = 0, distribution: UIStackView.Distribution = .equalSpacing) {
		self.init()
		self.axis = axis
		self.spacing = spacing
		self.distribution = distribution
	}
	
	@objc func addArrangedSubviews(_ views: [UIView]) {
		for view in views {
			self.addArrangedSubview(view)
		}
	}
	
	@objc func removeAll() {
		subviews.forEach { $0.removeFromSuperview() }
	}
}
