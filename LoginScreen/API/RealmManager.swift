//
//  RealmManager.swift
//  LoginScreen
//
//  Created by Ankitha Kamath on 31/10/21.
//

import Foundation
import RealmSwift
import SwiftUI

struct RealmManager {
    static var shared = RealmManager()
    let realmInstance = try! Realm()
    var notesRealm : [NotesItem] = []
    
    func addNote(note:NotesItem){
        try! realmInstance.write({
            realmInstance.add(note)
        })
    }
    
    mutating func deleteNote(note: NoteItem){
        for realmNote in notesRealm{
            if realmNote.title == note.title{
                try! realmInstance.write({
                    realmInstance.delete(realmNote)
                })
            }
        }
      
        
    }
    
    func updateNote(_ title:String,_ noteContent:String){
        let realmInstance = try! Realm()
        
    }
    
    mutating  func fetchNotes() {
        //var notesArray :[NotesItem] = []
        let notes = realmInstance.objects(NotesItem.self)
        for note in notes
        {
            notesRealm.append(note)
            //notesArray.append(note)
            
        }
//        completion(notesArray)
        print(notes)
        
    }
}
