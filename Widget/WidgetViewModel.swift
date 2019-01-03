//
//  WidgetViewModel.swift
//  widget
//
//  Created by Roman Spirichkin on 02/01/2019.
//  Copyright © 2019 perfectware. All rights reserved.
//

import EventKit
import NotificationCenter

protocol WidgetViewModelDelegate: class {
	func didReload()
	func didUpdate(atIndex index: Int)
	func didDelete(atIndices indices: [Int])
}

final class WidgetViewModel: NSObject {
	private enum UX {
		static let selectionDelay = 2.0
		static let defaultsKey = "mama.reminders"
	}
	
	weak var delegate: WidgetViewModelDelegate?
	
	var cellModels: [WidgetCheckCellModel] { return items }
	private var items: [Item] = []
	private var reminders = [EKReminder]()
	private let eventStore = EKEventStore()
	private var reloadHandler: ((NCUpdateResult) -> Void)?
	
	private var lastSelectedIndex: Int?
	private var lastSelectedTime = DispatchTime.now()
	
	func didSelect(atIndex index: Int) {
		didSelect(reminder: items[index].reminder)
	}

	private func didSelect(reminder: EKReminder) {
		guard let index = items.firstIndex(where: { $0.reminder === reminder }) else { return }
		let item = items[index]
		item.isSelected = !item.isSelected
		delegate?.didUpdate(atIndex: index)
		lastSelectedIndex = index
		lastSelectedTime = .now()
		DispatchQueue.global().asyncAfter(deadline: .now() + UX.selectionDelay) { [weak self] in
			guard let self = self else { return }
			guard self.lastSelectedTime + UX.selectionDelay * 0.95 < .now() else { return }
			guard let lastSelectedIndex = self.lastSelectedIndex, lastSelectedIndex == index else { return }
			let indices = self.items.enumerated().filter { $0.element.isSelected }.map { $0.offset }
			indices.reversed().forEach {
				self.reminders[$0].isCompleted = true
				_ = try? self.eventStore.save(self.reminders[$0], commit: true)
				self.reminders.remove(at: $0)
				self.items.remove(at: $0)
			}
			if self.items.isEmpty {
				self.delegate?.didReload()
			} else {
				self.delegate?.didDelete(atIndices: indices)
			}
			self.lastSelectedIndex = nil
		}
	}
	
	private func getReminders() {
		guard EKEventStore.authorizationStatus(for: .reminder) == .authorized else {
			return requestAccess()
		}
		let calendars = eventStore.calendars(for: .reminder).filter { $0.title == listTitle }
		let predicate = eventStore.predicateForReminders(in: calendars)
		eventStore.fetchReminders(matching: predicate) { [weak self] in
			guard let self = self else { return }
			let newReminders = ($0 ?? []).filter { $0.isCompleted == false }
			guard self.reminders != newReminders else {
				self.reloadHandler?(.noData)
				self.reloadHandler = nil
				return
			}
			self.reminders = newReminders
			self.items = newReminders.map { reminder in
				return Item(reminder: reminder) { [weak self] in
					self?.didSelect(reminder: reminder)
				}
			}
			self.delegate?.didReload()
			self.reloadHandler?(.newData)
			self.reloadHandler = nil
		}
	}
	
	private func requestAccess() {
		eventStore.requestAccess(to: .reminder) { [weak self] in
			guard let self = self, $0 else {
				return print($1 ?? "")
			}
			self.getReminders()
		}
	}
}

// MARK: - WidgetProviding

extension WidgetViewModel: NCWidgetProviding {
	func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
		reloadHandler?(.noData)
		reloadHandler = completionHandler
		getReminders()
	}
}

// MARK: - Item

private final class Item: WidgetCheckCellModel {
	var title: String {
		return reminder.title
	}
	var isSelected = false
	let selectAction: EmptyClosure
	unowned let reminder: EKReminder

	init(reminder: EKReminder, selectAction: @escaping EmptyClosure) {
		self.reminder = reminder
		self.selectAction = selectAction
	}
}
