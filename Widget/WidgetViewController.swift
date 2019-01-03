//
//  WidgetViewController.swift
//  widget
//
//  Created by Roman Spirichkin on 02/01/2019.
//  Copyright © 2019 perfectware. All rights reserved.
//

import UIKit
import NotificationCenter

final class WidgetViewController: UIViewController {
	private enum UI {
		static let rowHeight: CGFloat = 44
		static let footerHeight: CGFloat = rowHeight / 2
		static let compactTotalHeight: CGFloat = 110
		static let animationDuration = 0.5
	}
	private enum UX {
		static let compactMaxCount = 2
		static let expandedMaxCount = 10
	}
	private typealias Cell = UITableViewCell
	
	@IBOutlet weak var tableView: UITableView!
	
	private let viewModel = WidgetViewModel()
	private var cellsCount: Int {
		return viewModel.cellModels.count
	}

	private var isCompact: Bool {
		guard let extensionContext = extensionContext else { return true }
		return extensionContext.widgetActiveDisplayMode == .compact
	}
	private var willCompact = false
	private var likeCompact: Bool {
		return isCompact || willCompact
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.rowHeight = UI.rowHeight
		extensionContext?.widgetLargestAvailableDisplayMode = .expanded
		widgetActiveDisplayModeDidChange(.expanded, withMaximumSize: view.frame.size)
		
		viewModel.delegate = self
	}
}

// MARK: - WidgetProviding

extension WidgetViewController: NCWidgetProviding {
	func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
		viewModel.widgetPerformUpdate(completionHandler: completionHandler)
	}
	
	func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
		updateHeight(activeDisplayMode, withMaximumSize: maxSize, needReload: true)
	}
	
	private func updateHeight(force: Bool) {
		let mode = extensionContext?.widgetActiveDisplayMode ?? .compact
		guard force || !isCompact && cellsCount > UX.compactMaxCount
			&& preferredContentSize.height < UI.compactTotalHeight else { return }
		let size = preferredContentSize
		updateHeight(mode, withMaximumSize: size, needReload: false)
	}
	
	private func updateHeight(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize, needReload: Bool = false) {
		let nextSize: CGSize
		switch activeDisplayMode {
		case .compact:
			willCompact = true
			nextSize = maxSize
		case .expanded:
			willCompact = false
			let width = (tableView?.contentSize ?? maxSize).width
			let height = CGFloat(min(cellsCount, UX.expandedMaxCount)) * UI.rowHeight
			nextSize = CGSize(width: width, height: height)
		}
		UIView.animate(withDuration: UI.animationDuration) { [weak self] in
			self?.preferredContentSize = nextSize
			if needReload {
				self?.tableView.reloadData()
			}
			self?.willCompact = false
		}
	}
}

// MARK: - DataSource

extension WidgetViewController: UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return isCompact ? min(UX.compactMaxCount, cellsCount) : cellsCount
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "check") else { fatalError() }
		(cell as? WidgetCheckCell)?.viewModel = viewModel.cellModels[indexPath.row]
		return cell
	}
	
	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let size = CGSize(width: tableView.frame.width, height: UI.footerHeight)
		let rect = CGRect(origin: .zero, size: size)
		guard cellsCount != 0 else {
			let footer = WidgetFooter(frame: rect)
			footer.text = "все купила"
			return footer
		}
		guard isCompact && cellsCount > UX.compactMaxCount else {
			let footer = UIView()
			footer.isUserInteractionEnabled = false
			return footer
		}
		let footer = WidgetFooter(frame: rect)
		footer.text = "еще не всё"
		return footer
	}
}

// MARK: - Delegate

extension WidgetViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.didSelect(atIndex: indexPath.row)
	}
}

// MARK: - ViewModelDelegate

extension WidgetViewController: WidgetViewModelDelegate {
	func didReload() {
		DispatchQueue.main.async { [weak self] in
			self?.tableView.reloadData()
				self?.updateHeight(force: false)
		}
	}

	func didUpdate(atIndex index: Int) {
		DispatchQueue.main.async { [weak self] in
			self?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
		}
	}
	
	func didDelete(atIndices indices: [Int]) {
		DispatchQueue.main.async { [weak self] in
			self?.tableView.deleteRows(at: indices.map { IndexPath(row: $0, section: 0) }, with: .automatic)
			self?.updateHeight(force: true)
		}
	}
}

