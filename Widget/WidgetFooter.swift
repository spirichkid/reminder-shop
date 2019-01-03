//
//  WidgetFooter.swift
//  reminder-shop
//
//  Created by Roman Spirichkin on 1/2/19.
//  Copyright © 2019 perfectware. All rights reserved.
//

import UIKit

final class WidgetFooter: UIView {
	private let label = UILabel()
	
	var text: String? {
		set {
			label.text = newValue
		}
		get {
			return label.text
		}
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	private func setup() {
		label.frame.origin.y = 3
		label.frame.size = frame.size
		label.textAlignment = .center
		label.font = UIFont.systemFont(ofSize: 12)
		label.textColor = UIColor.black.withAlphaComponent(0.7)
		addSubview(label)
		let separator = UIView()
		separator.backgroundColor = UIColor.black.withAlphaComponent(0.1)
		separator.frame.size = CGSize(width: frame.size.width, height: 1)
		addSubview(separator)
	}
}
