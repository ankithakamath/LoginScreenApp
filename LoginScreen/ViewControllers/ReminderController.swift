//
//  ReminderController.swift
//  LoginScreen
//
//  Created by Ankitha Kamath on 09/11/21.
//

import Foundation
import UIKit

class ReminderController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var completion: ((Date) -> Void)?
    
    var width: CGFloat = 0
    let layout = UICollectionViewFlowLayout()
    var delegate: HomecControllerDelegate?
    //var noteArray: [NoteItem] = []
    var hasMoreNotes = true
    var remindArray: [NoteItem] = []
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if NetworkManager.manager.getUID() != nil {
            fetchData()
        }
    }
    
    func configureNavigationBar() {
        
        navigationItem.title = "Reminders"
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
    
    
    @objc func handleMenu() {
        delegate?.handleMenuToggle(forMenuOption: nil)
        
    }
    
    func fetchData() {
        
        NetworkManager.manager.fetchRemindNotes { result in
            
            switch result {
            case .success(let notes):
                self.remindArray = notes
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            case .failure(let error):
                self.showAlert(title: "error has occured", message: error.localizedDescription)
            }
        }
    }
    
}


extension ReminderController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(remindArray.count)
        return remindArray.count
    }
    
    func getCurrentDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.layer.cornerRadius = 10
        let note = remindArray[indexPath.row]
        
        cell.title.text = note.title
        cell.noteDescription.text = note.description
        cell.dateLabel.text = getCurrentDate(date: note.time)
        cell.currentNote = note
        // cell.delegate = self
        
        return cell
    }
    
}

