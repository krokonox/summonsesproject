//
//  CalendarSyncManager.swift
//  Summonses
//
//  Created by Smikun Denis on 28.01.2019.
//  Copyright © 2019 neoviso. All rights reserved.
//

import UIKit
import EventKit

enum CalendarType: String {
	case vacationDays = "Vacation Days"
	case individualVacation = "Individual Vacation"
	case payDays = "Pay Days"
}

class CalendarSyncManager: NSObject {
	
	public static let shared = CalendarSyncManager()
	
	var isExportCalendar : Bool {
		get {
			return UserDefaults.standard.bool(forKey: "exportCalendar")
		}
		set {
			UserDefaults.standard.set(newValue, forKey: "exportCalendar")
			UserDefaults.standard.synchronize()
		}
	}
	
	let eventStore = EKEventStore()
	
	func syncCalendar() {
		if isExportCalendar {
			syncVacationDays()
			syncIndividualVacationDays()
		} else {
			removeCalendars()
		}
	}
	
	private func syncVacationDays() {
		createCalendar(.vacationDays) { (seccuss, calendar) -> (Void) in
			if seccuss {
				DispatchQueue.main.async {
					let vocationModels = DataBaseManager.shared.getVocationDays()
					for model in vocationModels {
						self.createEvent(calendar: calendar, title: "Vacation Day", startDate: model.startDate!, endDate: model.endDate!)
					}
				}
			}
		}
	}
	
	private func syncIndividualVacationDays() {
		createCalendar(.individualVacation) { (seccuss, calendar) -> (Void) in
			if seccuss {
				DispatchQueue.main.async {
					let vocationModels = DataBaseManager.shared.getIndividualVocationDay()
					for model in vocationModels {
						self.createEvent(calendar: calendar, title: "Individual Vocation Day", startDate: model.date!, endDate: model.date!)
					}
				}
			}
		}
	}
	
	private func syncPayDays() {
		createCalendar(.payDays) { (seccuss, calendar) -> (Void) in
			if seccuss {
				DispatchQueue.main.async {
					let vocationModels = DataBaseManager.shared.getIndividualVocationDay()
					for model in vocationModels {
						self.createEvent(calendar: calendar, title: "Individual Vocation Day", startDate: model.date!, endDate: model.date!)
					}
				}
			}
		}
	}
	
	private func removeCalendars() {
		removeCalendar(.individualVacation)
		removeCalendar(.vacationDays)
	}
	private func removeCalendar(_ type: CalendarType) {
		eventStore.requestAccess(to: .event) { (granted, error) in
			if granted {
				//search calendar
				for calendar in self.eventStore.calendars(for: .event) {
					if calendar.title.elementsEqual(type.rawValue) {
						do {
							try self.eventStore.removeCalendar(calendar, commit: true)
						} catch {
							print(error)
						}
					}
				}
			}
		}
	}
	
	private func createCalendar(_ type: CalendarType, completionHandler:@escaping (_ success: Bool, _ calendar: EKCalendar)->(Void)) {
		eventStore.requestAccess(to: .event) { (granted, error) in
			if granted {
				var color: CGColor!
				//search calendar
				for calendar in self.eventStore.calendars(for: .event) {
					if calendar.title.elementsEqual(type.rawValue) {
						do {
							color = calendar.cgColor
							try self.eventStore.removeCalendar(calendar, commit: true)
						} catch {
							print(error)
						}
//						completionHandler(true, calendar)
//						return
					}
				}
				
				let newCalendar = EKCalendar(for: .event, eventStore: self.eventStore)
				newCalendar.title = type.rawValue
				newCalendar.cgColor = color
				
				let sourcesInEventStore = self.eventStore.sources
				let filteredSources = sourcesInEventStore.filter { $0.sourceType == .local }
				if let localSource = filteredSources.first {
					newCalendar.source = localSource
					do {
						try self.eventStore.saveCalendar(newCalendar, commit: true)
						completionHandler(true, newCalendar)
					} catch let error as NSError {
						completionHandler(false, newCalendar)
						print(error)
					}
				} else {
					// Somehow, the local calendar was not found, handle error accordingly
				}
			} else {
				// check error and alert the user
				Alert.show(title: "Error", subtitle: "No access to the calendar")
			}
		}
	}
	
	private func createEvent(calendar: EKCalendar, title: String, startDate: Date, endDate: Date) {
		let event = EKEvent(eventStore: eventStore)
		event.title = title
		event.startDate = startDate
		event.endDate = endDate
		event.calendar = calendar
		
		do {
			try eventStore.save(event, span: .thisEvent)
		} catch {
			print("Bad things happened")
		}
	}

}
