//
//  NagMe.swift
//  NagMeReminder
//
//  Created by Krishna Alex on 8/15/23.
//

import Foundation

struct NagMe: Equatable {
    var id: Int
    var type: String
    
    static var all: [NagMe] {
        return [
            NagMe(id: 0, type: "Off"),
            NagMe(id: 1, type: "Every Minute"),
            NagMe(id: 2, type: "Every 5 Minutes"),
            NagMe(id: 3, type: "Every 15 Minutes"),
            NagMe(id: 4, type: "Every 30 Minutes"),
            NagMe(id: 5, type: "Every Hour"),
            NagMe(id: 6, type: "Every Day")
        ]
    }
    static func ==(lhs: NagMe, rhs: NagMe) -> Bool {
        return lhs.id == rhs.id
    }
}
