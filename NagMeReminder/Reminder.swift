//
//  Reminder.swift
//  NagMeReminder
//
//  Created by Krishna Alex on 8/15/23.
//

import Foundation

struct Reminder: Equatable, Codable {
    let id: UUID
    var title: String
    var isComplete: Bool
    var alarm: Date
    var nagMe: NagMe
    var notes: String
    
    init(title: String, isComplete: Bool, alarm: Date, nagMe: NagMe, notes: String) {
        self.id = UUID()
        self.title = title
        self.isComplete = isComplete
        self.alarm = alarm
        self.nagMe = nagMe
        self.notes = notes
    }
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let activeURL = documentsDirectory.appendingPathComponent("activeReminders").appendingPathExtension("plist")
    //static let doneURL = documentsDirectory.appendingPathComponent("doneReminders").appendingPathExtension("plist")
    
 //   var nagMe: NagMe
 //   var repeatType: RepeatType

    static func ==(lhs: Reminder, rhs: Reminder) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func loadReminders() -> [Reminder]?  {
        guard let codedReminders = try? Data(contentsOf: activeURL) else {return nil}
        let propertyListDecoder = PropertyListDecoder()
        return try? propertyListDecoder.decode(Array<Reminder>.self, from: codedReminders)
    }
    
    static func saveReminders(_ reminders: [Reminder]) {
        let propertyListEncoder = PropertyListEncoder()
        let codedReminders = try? propertyListEncoder.encode(reminders)
        try? codedReminders?.write(to: activeURL, options: .noFileProtection)
    }
    
    static func loadSampleReminders() -> [Reminder] {
        let reminder1 = Reminder(title: "Reminder1", isComplete: false,
                                 alarm: Date(), nagMe: NagMe.all[0], notes: "Reminder1")
        let reminder2 = Reminder(title: "Reminder2", isComplete: false,
                                 alarm: Date(), nagMe: NagMe.all[0], notes: "Reminder1")
        let reminder3 = Reminder(title: "Reminder3", isComplete: false,
                                 alarm: Date(), nagMe: NagMe.all[0], notes: "Reminder1")

        return [reminder1, reminder2, reminder3]
    }
}
