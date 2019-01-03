//
//  UIImage+Extension.swift
//  reminder-shop
//
//  Created by Roman Spirichkin on 02/01/2019.
//  Copyright © 2019 perfectware. All rights reserved.
//

import UIKit

extension UIImage {
	convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
		let rect = CGRect(origin: .zero, size: size)
		UIGraphicsBeginImageContextWithOptions(size, false, 0)
		color.setFill()
		UIRectFill(rect)
		guard let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }
		UIGraphicsEndImageContext()
		self.init(cgImage: cgImage)
	}
}
