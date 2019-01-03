//
//  WidgetCheckCell.swift
//  widget
//
//  Created by Roman Spirichkin on 02/01/2019.
//  Copyright © 2019 perfectware. All rights reserved.
//

import UIKit

protocol WidgetCheckCellModel {
	var title: String { get }
	var isSelected: Bool { get }
	var selectAction: EmptyClosure { get }
}

final class WidgetCheckCell: UITableViewCell {
	@IBOutlet weak var button: UIButton!
	@IBOutlet weak var label: UILabel!
	
	var viewModel: WidgetCheckCellModel? {
		didSet {
			refresh()
		}
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		button.setImage(#imageLiteral(resourceName: "undone"), for: .normal)
		button.setImage(#imageLiteral(resourceName: "done"), for: .selected)
		button.setImage(#imageLiteral(resourceName: "done"), for: .highlighted)
		button.backgroundColor = UIColor.clear
		button.addTarget(self, action: #selector(didTap), for: .touchDown)
		label.isUserInteractionEnabled = false
	}
	
	private func refresh() {
		button.isSelected = viewModel?.isSelected ?? false
		label.text = viewModel?.title
	}
	
	@objc
	private func didTap() {
		viewModel?.selectAction()
	}
}
