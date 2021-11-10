//
//  NotesItem.swift
//  LoginScreen
//
//  Created by Ankitha Kamath on 31/10/21.
//

import Foundation

import RealmSwift

class NotesItem: Object {
    @objc dynamic var name = ""
    @objc dynamic  var title = ""
    @objc dynamic  var note = ""
    @objc dynamic  var uid = ""
    @objc dynamic   var date = Date()
    
    
}
