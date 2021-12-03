//
//  note.swift
//  LoginScreen
//
//  Created by Ankitha Kamath on 28/10/21.
//

import Foundation
 import FirebaseFirestore

struct NoteItem {
    var id : String?
    var title: String
    var description: String
    var uid: String
    var time: Date
    var isArchive: Bool
    var reminderTime: Date?
    
    var dictionary: [String: Any] {
           return[
          
           "title": title,
           "description": description,
           "uid":uid,
           "time":time,
            "isArchive": isArchive,
           "reminderTime": reminderTime
           ]
       }
}
