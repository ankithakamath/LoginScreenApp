//
//  NetworkManager.swift
//  LoginScreen
//
//  Created by Ankitha Kamath on 28/10/21.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore


var fetchingMoreNotes = false
var lastDocument: QueryDocumentSnapshot?
let uid = Auth.auth().currentUser?.uid
let db = Firestore.firestore()

struct NetworkManager {
    
    static let manager = NetworkManager()
    
    
    func signUp(withEmail email: String, password: String, completion:AuthDataResultCallback?){
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }
    
    func login(withEmail email: String, password: String, completion:AuthDataResultCallback?){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
    }
    
    func signout() -> Bool{
        
        do {
            try Auth.auth().signOut()
            
        }catch{
            
        }
        return true
    }
    
    
    
    func getUID() -> String? {
        return uid
    }
    
    func deleteNote(note: NoteItem) {
        
        let db = Firestore.firestore()
        db.collection("notes").document(note.id!).delete {
            error in
            
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    func getNotes( completion: @escaping([NoteItem]) -> Void) {
        let db = Firestore.firestore()
        db.collection("notes").whereField("uid", isEqualTo: NetworkManager.manager.getUID()).getDocuments() { snapshot, error in
            var noteItem = [NoteItem]()
            if let error = error {
                
                return
            }
            guard let snapshot = snapshot else {return}
            for document in snapshot.documents {
                
                let data = document.data()
                let id = document.documentID
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let uid = data["uid"] as? String ?? ""
                let time = (data["time"] as? Timestamp)?.dateValue() ?? Date()
                let isArchive = data["isArchive"] as? Bool ?? false
                let note = NoteItem(id: id, title: title, description: description, uid: uid, time: time, isArchive: isArchive)
                
                noteItem.append(note)
            }
            completion(noteItem)
        }
    }
    
    func addNoteToFirebase(note: NoteItem, completion: @escaping(Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("notes").addDocument(data: note.dictionary)
    }
    
    func addNote(note: [String: Any]) {
        
        let db = Firestore.firestore()
        db.collection("notes").addDocument(data: note)
        
    }
    
    func updateNote(note: NoteItem) {
        
        let db = Firestore.firestore()
        db.collection("notes").document(note.id!).updateData(note.dictionary) {
            error in
            
            if let error = error {
                
                print(error.localizedDescription)
            }
        }
        
    }
    
    func downloadImage(fromURL urlString: String, completion: @escaping(UIImage?) -> Void) {
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            let image = UIImage(data: data)
            completion(image)
        }
        
        task.resume()
    }
    
    func resultType(completion: @escaping(Result<[NoteItem], Error>) -> Void) {
        
        guard let uid = NetworkManager.manager.getUID() else { return }
        
        db.collection("notes").whereField("user", isEqualTo: uid).limit(to: 10).getDocuments { snapshot, error in
            var notes: [NoteItem] = []
            
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            for doc in snapshot.documents {
                let data = doc.data()
                let id = doc.documentID
                let title = data["title"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let user = data["user"] as? String ?? ""
                let time = (data["time"] as? Timestamp)?.dateValue() ?? Date()
                let isArchive = data["isArchive"] as? Bool ?? false
                let note = NoteItem(id: id, title: title, description: description, uid: uid, time: time, isArchive: isArchive)
                
                notes.append(note)
            }
            lastDocument = snapshot.documents.last
            //            completion(notes, nil)
            completion(.success(notes))
        }
    }
    
    
    
    func fetchNotes(archived: Bool, completion: @escaping(Result<[NoteItem], Error>) -> Void) {
       // Firestore.firestore().collection(uid!).whereField("archived", isEqualTo: archived).order(by: "timeStamp").limit(to: 8)
        db.collection("notes").whereField("isArchive", isEqualTo: archived).order(by: "time").limit(to: 8).getDocuments { snapshot,error in
            var notes : [NoteItem] = []
            if let error = error {
                completion(.failure(error))
                print(error.localizedDescription)
                return
            }
            if snapshot != nil {
                for document in snapshot!.documents {
                    let data = document.data()
                    let id = document.documentID
                    let title = data["title"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let uid = data["uid"] as? String ?? ""
                    let time = (data["time"] as? Timestamp)?.dateValue() ?? Date()
                    let isArchive = data["isArchive"] as? Bool ?? false
                    let note = NoteItem(id: id, title: title, description: description, uid: uid, time: time, isArchive: isArchive)
                    notes.append(note)
                }
                
                lastDocument = snapshot?.documents.last
                print("+++++++++++++++++++++++++++++++\(notes.count)")
                completion(.success(notes))
                
            }
            
        }
        
    }
    
    
    func fetchMoreNotes(completion: @escaping([NoteItem]) -> Void){
        fetchingMoreNotes = true
        guard let lastNoteDocument = lastDocument else { return }
        db.collection("notes").order(by: "time").start(afterDocument: lastNoteDocument).limit(to: 8).getDocuments { snapshot, error in
            var notes : [NoteItem] = []
            if let error = error {
                print(error.localizedDescription)
                
            }
            if snapshot != nil {
                
                for document in snapshot!.documents {
                    let data = document.data()
                    let id = document.documentID
                    let title = data["title"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let uid = data["uid"] as? String ?? ""
                    let time = (data["time"] as? Timestamp)?.dateValue() ?? Date()
                    let isArchive = data["isArchive"] as? Bool ?? false
                    let note = NoteItem(id: id, title: title, description: description, uid: uid, time: time, isArchive: isArchive)
                    notes.append(note)
                }
                
                lastDocument = snapshot!.documents.last
                print(notes)
                
                fetchingMoreNotes = false
                print("\(notes.count)====================================================")
                completion(notes)
            }
        }
        
    }
    
}



