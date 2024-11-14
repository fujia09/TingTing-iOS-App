//
//  NoteItem.swift
//  NoteDemo
//
//  Created by fujia wang on 2021/11/18.
//

import SwiftUI

struct NoteItem: Identifiable, Codable {  // note model.
    var id = UUID().uuidString  // id.
    var noteTitle: String  // note title.
    var endTime: String  // time of the last modification.
//    var date: Date
    var content: String  // note content.
    var isSwiped: Bool  // a flag variable is used to determine whether the note item view has been swiped.
    var offset: CGFloat  // swiping distance.
    
//    init(noteTitle: String, endTime: String, content: String, isSwiped: Bool, offset: CGFloat) {
//        self.noteTitle = noteTitle
//        self.endTime = endTime
//        self.content = content
//        self.isSwiped = isSwiped
//        self.offset = offset
//    }
}

