//
//  String+Extension.swift
//  reminder-shop
//
//  Created by Roman Spirichkin on 02/01/2019.
//  Copyright © 2019 perfectware. All rights reserved.
//

import UIKit

extension String {
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}
}
