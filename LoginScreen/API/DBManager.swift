//
//  DBManager.swift
//  LoginScreen
//
//  Created by Ankitha Kamath on 08/11/21.
//
import Foundation
import UIKit

struct DatabaseManager {
    static let shared = DatabaseManager()
    
    func deleteNote(note: NoteItem) {
        NetworkManager.manager.deleteNote(note: note)
    }
}
