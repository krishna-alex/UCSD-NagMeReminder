//
//  RepeatType.swift
//  NagMeReminder
//
//  Created by Krishna Alex on 8/15/23.
//

import Foundation

struct RepeatType: Equatable {
    var id: Int
    var type: String
    //var name: String
    //var price: Double
    
    static var all: [RepeatType] {
        return [
            RepeatType(id: 0, type: "Never"),
            RepeatType(id: 1, type: "Every Day"),
            RepeatType(id: 2, type: "Every Weekday(Mon - Fri)"),
            RepeatType(id: 3, type: "Every Month"),
            RepeatType(id: 4, type: "Every Year")
        ]
    }
    static func ==(lhs: RepeatType, rhs: RepeatType) -> Bool {
        return lhs.id == rhs.id
    }
}
