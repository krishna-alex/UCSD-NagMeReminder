//
//  Reminder.swift
//  NagMeReminder
//
//  Created by Krishna Alex on 8/15/23.
//

import Foundation

struct Reminder: Equatable {
    let id = UUID()
    var title: String
    var isComplete: Bool
    var alarm: Date
    
 //   var nagMe: NagMe
 //   var repeatType: RepeatType

    static func ==(lhs: Reminder, rhs: Reminder) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func loadReminders() -> [Reminder]?  {
        return nil
    }
    
    static func loadSampleReminders() -> [Reminder] {
        let reminder1 = Reminder(title: "Reminder1", isComplete: false,
                                 alarm: Date())
        let reminder2 = Reminder(title: "Reminder2", isComplete: false,
                                 alarm: Date())
        let reminder3 = Reminder(title: "Reminder3", isComplete: false,
                                 alarm: Date())

        return [reminder1, reminder2, reminder3]
    }
}
