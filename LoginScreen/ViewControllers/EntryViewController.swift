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
    var reminder: Date? = nil
    let uid = Auth.auth().currentUser?.uid
    
    
    @IBOutlet var titleField: UITextField!
    @IBOutlet var noteField: UITextView!
   
    @IBOutlet weak var reminderTime: UIDatePicker!
    
    //public var completion:((String, String) -> Void)/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.becomeFirstResponder()
        if isNew{
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        }else{
        let save = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(didTapSave))
        let archiveButton = UIBarButtonItem(image: UIImage(named: "arc"), style: .plain, target: self, action: #selector(archiveNote))
           
            navigationItem.rightBarButtonItems = [ archiveButton, save]
       
    }
        newData()
    }
    
    
    @IBAction func reminderButton(_ sender: UIButton) {
        print(".......................................")
        reminder = reminderTime.date
        showAlert(title: "notes", message: "reminder set successfully")
    }
    
    @objc func archiveNote(){
        note!.isArchive = !note!.isArchive
        NetworkManager.manager.updateNote(note: note!)
      
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
                

             let newNote: [String: Any] = ["title": title, "description": noteDescription,"uid": uid!,"time" : Date(),"isArchive": false, "reminderTime": reminder]
                
                NetworkManager.manager.addNote(note: newNote)
                dismiss(animated: true, completion: nil)
                let note1 = NotesItem()
                note1.note = noteField.text
                note1.title = titleField.text!
                note1.uid = uid!
                note1.date = Date()
                      // RealmManager.shared.addNote(note: note1)
                       
                self.titleField.text = ""
                       self.noteField.text = ""
                
            } else {
                note?.title = titleField.text!
                note?.description = noteField.text
                note?.reminderTime = reminder
                
                if note?.reminderTime != nil {
                    notificationReminder(note: note!)

                NetworkManager.manager.updateNote(note: note!)
               
            }
       
        }
        navigationController?.popViewController(animated: true)
    }
    
    func getCurrentDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
        
    }
    func notificationReminder(note : NoteItem){
           
           UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
               
               
               let content = UNMutableNotificationContent()
               content.title = note.title
               content.sound = .default
               content.body = note.description
               
               let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: note.reminderTime!), repeats: false)
               
               let request = UNNotificationRequest(identifier: "some_long_id", content: content, trigger: trigger)
               UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
                   
                   if error != nil {
                  
                   }
                   
               })
               
           }
       }
       
    func printNotes(){
            
            let notes = realmInstance.objects(NotesItem.self)
            for note in notes
            {
                print(note)
            }
        }
   
}




