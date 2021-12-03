//
//  NoteViewController.swift
//  LoginScreen
//
//  Created by Ankitha Kamath on 27/10/21.
//

import UIKit

class ArchivesController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        width = view.frame.width - 20
        fetchData()
        self.collectionView.reloadData()
        configureCollectionView()
    }
    
    @objc func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var width: CGFloat = 0
    let layout = UICollectionViewFlowLayout()
    var delegate: HomecControllerDelegate?
    var noteArray: [NoteItem] = []
    var hasMoreNotes = true
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if NetworkManager.manager.getUID() != nil {
            fetchData()
        }
    }
    
    func configureNavigationBar() {
        
        navigationItem.title = "Archives"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "cancel")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
    }
    
    func configureCollectionView() {
        let itemSize = UIScreen.main.bounds.width - 40
        
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 20)
        layout.itemSize = CGSize(width: itemSize, height: 200)
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    
    func updateCollectionView(notes: [NoteItem]) {
        self.noteArray = notes
        print(noteArray.count)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    @objc func handleMenu() {
        delegate?.handleMenuToggle(forMenuOption: nil)
        
    }
    
    func fetchData() {
        
        NetworkManager.manager.fetchNotes(archived: true) { result in
            
            switch result {
            case .success(let notes):
                self.updateCollectionView(notes: notes)
                
            case .failure(let error):
                self.showAlert(title: "error has occured", message: error.localizedDescription)
            }
        }
    }
    
}


extension ArchivesController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(noteArray.count)
        return noteArray.count
    }
    
    func getCurrentDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 10
        let note = noteArray[indexPath.row]
        
        cell.title.text = note.title
        cell.noteDescription.text = note.description
        cell.dateLabel.text = getCurrentDate(date: note.time)
        cell.currentNote = note
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let addscreen = storyboard!.instantiateViewController(withIdentifier: "EntryViewController") as! EntryViewController
        addscreen.isNew = false
        addscreen.note = noteArray[indexPath.row]
        navigationController?.pushViewController(addscreen, animated: true)
    }
}


extension ArchivesController: DeleteCellDelegate {
    
    func deleteNote(note: NoteItem) {
        
        let deleteNote = {
            DatabaseManager.shared.deleteNote(note: note)
            self.fetchData()
        }
        
        showAlertWithCancel(title: "Delete " + note.title, message: "Are you Sure", buttonText: "Delete", buttonAction: deleteNote)
    }
}
