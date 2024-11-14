//
//  MeetInfo.swift
//  Scrumdinger
//
//

import SwiftUI

struct MeetingInfo: Identifiable, Codable {
    let id: UUID
    var title: String
    var attendees: [String]
    var color: Color
    var history: [String]

    init(id: UUID = UUID(), title: String, attendees: [String], color: Color, history: [String] = []) {
        self.id = id
        self.title = title
        self.attendees = attendees
        self.color = color
        self.history = history
    }
}

extension MeetingInfo {
    static var data: [MeetingInfo] {
        [
            
        ]
    }
}

extension MeetingInfo {
    struct Data {
        var title: String = ""
        var attendees: [String] = []
        var color: Color = .random
        var history: [String] = []
    }

    var data: Data {
        return Data(title: title, attendees: attendees, color: color, history: history)
    }

    mutating func update(from data: Data) {
        title = data.title
        attendees = data.attendees
        color = data.color
        history = data.history
    }
}
