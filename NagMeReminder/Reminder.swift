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
    var nagMe: NagMe
    var repeatType: RepeatType

    static func ==(lhs: Reminder, rhs: Reminder) -> Bool {
        return lhs.id == rhs.id
    }
}
