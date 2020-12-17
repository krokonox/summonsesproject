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
	case individualVacation = "IVD"
	case RDO = "RDO"
	case payDays = "Pay Days"
    case calendar = "RDO Calendar"
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
		let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
		switch (status) {
		case EKAuthorizationStatus.notDetermined:
			requestAccessToCalendar()
		case EKAuthorizationStatus.authorized:
			if isExportCalendar {
                createCalendar(.calendar) { (succuss, calendar) -> (Void) in
                    if succuss {
                        self.syncRDO(calendar)
                        self.syncVacationDays(calendar)
                        self.syncIndividualVacationDays(calendar)
                    }
                }
			} else {
				removeCalendars()
			}
		case EKAuthorizationStatus.restricted, EKAuthorizationStatus.denied:
			print("User has to change settings")
		}
	}
	
	func requestAccessToCalendar() {
		eventStore.requestAccess(to: .event, completion: { (granted, error) in
			if (granted) && (error == nil) {
				self.syncCalendar()
			} else{
				print(error?.localizedDescription ?? "requestAccessToCalendar error")
			}
		})
	}
    
    private func syncVacationDays(_ calendar : EKCalendar) {
		//createCalendar(.vacationDays) { (succuss, calendar) -> (Void) in
		//	if succuss {
				DispatchQueue.main.async {
					let vocationModels = DataBaseManager.shared.getVocationDays()
					for model in vocationModels {
                        self.createEvent(calendar: calendar, title: "Vacation Day", startDate: model.startDate!, endDate: model.endDate!)
					}
                    self.commitChanges()
				}
		//	}
		//}
	}
	
	private func syncRDO(_ calendar : EKCalendar) {
		//createCalendar(.RDO) { (succuss, calendar) -> (Void) in
		//	if succuss {
				var departmentModel = DepartmentModel(departmentType: .patrol, squad: .firstSquad)
                let settingsManager = SettingsManager.shared
                if settingsManager.permissionShowPatrol {
					departmentModel.departmentType = .patrol
                } else if settingsManager.permissionShowSRG {
					departmentModel.departmentType = .srg
				} else if settingsManager.permissionShowSteadyRDO {
                    departmentModel.departmentType = .steady
                } else {
                    departmentModel.departmentType = .custom
                }
				
                switch SettingsManager.shared.typeSquad {
				case 0:
					departmentModel.squad = .firstSquad
					break
				case 1:
					departmentModel.squad = .secondSquard
					break
				case 2:
					departmentModel.squad = .thirdSquad
					break
				default:
					break
				}
				
				SheduleManager.shared.department = departmentModel
				
				let weeks = SheduleManager.shared.getWeekends(firstDayMonth: Date().getVisibleStartDate(), lastDate: Date().getVisibleEndDate())
                DispatchQueue.main.async {
                    for date in weeks {
                        self.createEvent(calendar: calendar, title: "RDO", startDate: date, endDate: date)
                    }
                    self.commitChanges()
                }
		//	}
		//}
	}
	
	private func syncIndividualVacationDays(_ calendar : EKCalendar) {
		//createCalendar(.individualVacation) { (succuss, calendar) -> (Void) in
		//	if succuss {
				DispatchQueue.main.async {
					let vocationModels = DataBaseManager.shared.getIndividualVocationDay()
					for model in vocationModels {
						self.createEvent(calendar: calendar, title: "IVD", startDate: model.date!, endDate: model.date!)
					}
                    self.commitChanges()
				}
		//	}
		//}
	}
	
	private func syncPayDays(_ calendar : EKCalendar) {
		//createCalendar(.payDays) { (succuss, calendar) -> (Void) in
		//	if succuss {
				DispatchQueue.main.async {
					let vocationModels = DataBaseManager.shared.getIndividualVocationDay()
					for model in vocationModels {
						self.createEvent(calendar: calendar, title: "Pay Days", startDate: model.date!, endDate: model.date!)
					}
                    self.commitChanges()
				}
			//}
		//}
	}
	
    private func commitChanges() {
        //DispatchQueue.main.async {
        do {
            try self.eventStore.commit()
            print("Commit succuss!")
        } catch {
            print("Commit error!")
        }
        //}
    }
    
	private func removeCalendars() {
		removeCalendar(.individualVacation)
		removeCalendar(.vacationDays)
		removeCalendar(.RDO)
        removeCalendar(.calendar)
	}
	
	private func removeCalendar(_ type: CalendarType) {
        let eventStore = EKEventStore()
		eventStore.requestAccess(to: .event) { (granted, error) in
			if granted {
				//search calendar
                DispatchQueue.main.async {
				for calendar in self.eventStore.calendars(for: .event) {
					if calendar.title.elementsEqual(type.rawValue) {
						do {
							try self.eventStore.removeCalendar(calendar, commit: true)
                            //print("\(type.rawValue) removed")
						} catch {
							print(error)
						}
					}
				}
                }
			}
		}
	}
	
	private func createCalendar(_ type: CalendarType, completionHandler:@escaping (_ success: Bool, _ calendar: EKCalendar)->(Void)) {
		eventStore.requestAccess(to: .event) { (granted, error) in
			if granted {
                self.removeCalendar(type)
                
				let newCalendar = EKCalendar(for: .event, eventStore: self.eventStore)
                newCalendar.title = type.rawValue
				
				let sourcesInEventStore = self.eventStore.sources
                let filteredSources = sourcesInEventStore.filter { $0.sourceType ==  .calDAV || $0.sourceType == .subscribed || $0.sourceType == .local}
                //print(sourcesInEventStore)
				if let calDAVSource = filteredSources.first {
					newCalendar.source = calDAVSource
                    DispatchQueue.main.async {
                        do {
                            //print(newCalendar)
                            try self.eventStore.saveCalendar(newCalendar, commit: false)
                            //print("\(type.rawValue) added1")
                                completionHandler(true, newCalendar)
                        } catch let error as NSError {
                            print("error, calendar synchronization is disabled in icloud settings \(error)")
                            
                            if let localSource = filteredSources.last {
                                print("create local calendar")
                                newCalendar.source = localSource
                                do {
                                    try self.eventStore.saveCalendar(newCalendar, commit: false)
                                    //print("\(type.rawValue) added2")
                                    completionHandler(true, newCalendar)
                                } catch let error as NSError {
                                    completionHandler(false, newCalendar)
                                    print(error)
                                }
                            }
                        }
                    }
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
		event.isAllDay = true
		event.startDate = startDate
		event.endDate = endDate
		event.calendar = calendar
		
        //print(startDate.getDate()," ", endDate.getDate())
		do {
            try eventStore.save(event, span: .thisEvent, commit: true)
		} catch {
			print("Bad things happened")
		}
	}
	
}
