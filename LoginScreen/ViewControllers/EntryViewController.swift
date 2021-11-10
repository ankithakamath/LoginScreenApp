//
//  EntryViewController.swift
//  LoginScreen
//
//  Created by Ankitha Kamath on 27/10/21.
//

import UIKit
import FirebaseFirestore
import Firebase
import RealmSwift


class EntryViewController: UIViewController{
    
    let realmInstance = try! Realm()
    var noteArray = [NoteItem]()
    var isNew: Bool = true
    var note: NoteItem?
    var remindTime: Date? = nil
    let uid = Auth.auth().currentUser?.uid
    
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var noteField: UITextView!
   
    
    //public var completion:((String, String) -> Void)/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.becomeFirstResponder()
        if isNew{
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        }else{
        let save = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        let archiveButton = UIBarButtonItem(image: UIImage(named: "arc"), style: .plain, target: self, action: #selector(archiveNote))
            let remindButton = UIBarButtonItem(image: UIImage(named: "reminder"), style: .plain, target: self, action: #selector(navigatePicker))
            navigationItem.rightBarButtonItems = [remindButton, archiveButton, save]
       
    }
        newData()
    }
    
    @objc func navigatePicker() {
        let pickerScreen = storyboard!.instantiateViewController(withIdentifier: "ReminderController") as! ReminderController
                        
            navigationController?.pushViewController(pickerScreen, animated: true)
            
            pickerScreen.completion = { remindDate in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                    
                    self.remindTime = remindDate
                }
            }
        }
    
    @objc func archiveNote(){
        note!.isArchive = !note!.isArchive
        NetworkManager.manager.updateNote(note: note!)
        print("44444444444444444444444444444444444444444444444444444")
        navigationController?.popViewController(animated: true)
        
    }
    
    func newData(){
        
        titleField.text = note?.title
        noteField.text = note?.description
        
    }
    
 
    
    @objc func didTapSave(){
       
        guard let title = titleField.text else{return}
        guard let noteDescription = noteField.text else{return}
     
            if titleField.text == "" || noteField.text == "" {
                showAlert(title: "Notes", message: "Fields cannot be empty")
            }else if isNew{
                let newNote: [String: Any] = ["title": title, "description": noteDescription,"uid": uid!,"time" : Date(),"isArchive": false]
                NetworkManager.manager.addNote(note: newNote)
                dismiss(animated: true, completion: nil)
                let note1 = NotesItem()
                note1.note = noteField.text
                note1.title = titleField.text!
                note1.uid = uid!
                       note1.date = Date()
                       RealmManager.shared.addNote(note: note1)
                       
                self.titleField.text = ""
                       self.noteField.text = ""
                
            } else {
                note?.title = titleField.text!
                note?.description = noteField.text
                
                NetworkManager.manager.updateNote(note: note!)
               
            }
        navigationController?.popViewController(animated: true)
        }
        
    
    func printNotes(){
            
            let notes = realmInstance.objects(NotesItem.self)
            for note in notes
            {
                print(note)
            }
        }
   
}




