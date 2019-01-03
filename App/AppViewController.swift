//
//  AppViewController.swift
//  reminder-shop
//
//  Created by Roman Spirichkin on 02/01/2019.
//  Copyright © 2019 perfectware. All rights reserved.
//

import UIKit

final class AppViewController: UIViewController {
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		guard let url = reminderURL else { return }
		UIApplication.shared.open(url)
	}
}

