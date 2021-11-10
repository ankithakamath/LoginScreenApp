//
//  HomeViewController.swift
//  LoginScreen
//
//  Created by Ankitha Kamath on 20/10/21.
//

import UIKit
import GoogleSignIn
import FirebaseAuth
import RealmSwift

class HomeViewController: UIViewController{
    
    var note: NoteItem?
    let realmInstance = try! Realm()
    //var notesRealm : [NotesItem] = []
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    var searching = false
    var searchedText = [NoteItem]()
    let searchcontroller = UISearchController(searchResultsController: nil)
    var hasMoreNotes = true
    //var noteList: [NoteItem] = []
    var width: CGFloat = 0
    var noteArray :[NoteItem] = []
    var toggleButton = UIBarButtonItem()
    var delegate: HomecControllerDelegate?
    var flag = true
    
    
    func homeView(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        
        
    }
    
    func updateCollectionView(notes: [NoteItem]) {
        self.noteArray = notes
        print(noteArray.count)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func fetchData() {
        
        NetworkManager.manager.fetchNotes(archived: false) { result in

            switch result {
            case .success(let notes):
                self.updateCollectionView(notes: notes)
                
            case .failure(let error):
                self.showAlert(title: "error has occured", message: error.localizedDescription)
            }
        }
    }
    

        
          
        
        
    
    
    func fetchNoteRealm(){
        RealmManager.shared.fetchNotes()
        // self.notesRealm = notesArray

    }
    
    
    
    
    
    
    
    private func configuresearchController(){
        searchcontroller.loadViewIfNeeded()
        searchcontroller.searchResultsUpdater = self
        searchcontroller.searchBar.delegate = self
        //background contrast and search button
        searchcontroller.obscuresBackgroundDuringPresentation = false
        searchcontroller.searchBar.enablesReturnKeyAutomatically = false
        searchcontroller.searchBar.returnKeyType = UIReturnKeyType.done
        //search bar settings
        self.navigationItem.searchController = searchcontroller
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        //placeholder
        searchcontroller.searchBar.placeholder = "search the note via the content"
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
        self.collectionView.reloadData()
        width = view.frame.width - 20
        configuresearchController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hasMoreNotes = true
        fetchData()
        
    }
    
    
    
    
    @objc func handleMenuToggle(){
        delegate?.handleMenuToggle(forMenuOption: nil)
    }
    
    @objc func handleAddNote(){
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let addscreen = storyboard.instantiateViewController(withIdentifier: "EntryViewController") as! EntryViewController
        addscreen.isNew = true
        navigationController?.pushViewController(addscreen, animated: true)
        //print(noteArray)
    }
    
    
    
    func checkUserAlreadyLoggedIn(){
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if user == nil {
                DispatchQueue.main.async {
                    self.presentLoginScreen()
                }
            }
        }
    }
    
    func presentLoginScreen(){
        print("----------")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController) as! LoginViewController
        loginVC.modalPresentationStyle = .fullScreen
        
        self.present(loginVC, animated: true, completion: nil)
        
    }
    
    func configureNavigationBar(){
        
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .systemTeal
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        navigationItem.title = "Notes"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
       
        let addButton = UIBarButtonItem(image: UIImage(systemName: "folder.fill.badge.plus"), style: .done, target: self, action: #selector(handleAddNote))
        toggleButton = UIBarButtonItem(image: UIImage(systemName: "list.bullet.below.rectangle"), style: .done, target: self, action: #selector(toggleButtonTapped))
        //
        navigationItem.rightBarButtonItems = [addButton, toggleButton]
        //
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(handleMenuToggle))
        
    }
    
    
    @objc func toggleButtonTapped(){
        
        if !flag {
            
            flag = !flag
            width = (view.frame.width - 40)
            toggleButton.image = UIImage(systemName: "list.bullet.below.rectangle")
            print("\(width)+++++++++++++++++++++++++++++++++++++++++ if")
            collectionView.reloadData()
            
        }else {
            
            flag = !flag
            width = (view.frame.width - 40) / 2
            toggleButton.image = UIImage(systemName: "square.grid.2x2")
            
            print("\(width)+++++++++++++++++++++++++++++++++++++++++ else")
            collectionView.reloadData()
        }
        collectionView.reloadData()
        
    }
    
//    @objc func handleDelete(_ sender: UIButton){
//        let note = noteArray[sender.tag]
//        NetworkManager.manager.deleteNote(note: note)
//        RealmManager.shared.deleteNote(note: note)
//        noteArray.remove(at: sender.tag)
//        collectionView.reloadData()
//    }
    
    
    
    func getCurrentDate(date: Date) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        return dateFormatter.string(from: date)
        
    }
}

extension HomeViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if searching {
            return searchedText.count
        }else{
            return noteArray.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let addscreen = storyboard.instantiateViewController(withIdentifier: "EntryViewController") as! EntryViewController
        addscreen.isNew = false
        addscreen.note = noteArray[indexPath.row]
        navigationController?.pushViewController(addscreen, animated: true)
        if searching{
            addscreen.note = searchedText[indexPath.row]
        }else{
            addscreen.note = noteArray[indexPath.row]
        }
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let note = searching ? searchedText[indexPath.row] : noteArray[indexPath.row]
        cell.title.text = note.title
        cell.noteDescription.text = note.description
        cell.dateLabel.text = getCurrentDate(date: note.time)
        cell.currentNote = note
        cell.delegate = self
//        if searching{
//
//            cell.title.text = searchedText[indexPath.row].title
//            cell.noteDescription.text = searchedText[indexPath.row].description
////            cell.deleteButton.tag = indexPath.row
////            cell.deleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
//
//        }
//        else {
//
//            let note = noteArray[indexPath.row]
//            cell.title.text = note.title
//            cell.noteDescription.text = note.description
//            cell.dateLabel.text = getCurrentDate(date: note.time)
////            cell.deleteButton.tag = indexPath.row
////            cell.deleteButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
//        }
        cell.title.widthAnchor.constraint(equalToConstant:width).isActive = true
        return cell

    }
    
   
}


extension HomeViewController: DeleteCellDelegate {
    
    func deleteNote(note: NoteItem) {
        
        let deleteNote = {
            DatabaseManager.shared.deleteNote(note: note)
            self.searchcontroller.isActive = false
            self.fetchData()
        }
        
        showAlertWithCancel(title: "Delete " + note.title, message: "Are you Sure", buttonText: "Delete", buttonAction: deleteNote)
    }
}
extension HomeViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 5, bottom: 10, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
}

    

extension HomeViewController: UISearchResultsUpdating,UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        //let count = searchcontroller.searchBar.text?.count
        let searchText = searchController.searchBar.text!
        //if search text empty
        if !searchText.isEmpty {
            
            searching = true
            searchedText.removeAll()
            // searchedText = noteArray.filter({$0.title.prefix(count!).lowercased() == searchText.lowercased()})
            for title in noteArray{
                if title.title.lowercased().contains(searchText.lowercased()) || title.description.lowercased().contains(searchText.lowercased())
                    
                {
                    searchedText.append(title)
                }
            }
        }
        
        else {
            searching = false
            searchedText.removeAll()
            searchedText = noteArray
        }
        collectionView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchedText.removeAll()
        collectionView.reloadData()
    }
}




extension HomeViewController: UIScrollViewDelegate{
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let offset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offset>contentHeight - height{
           
            guard hasMoreNotes else {return}
            guard !fetchingMoreNotes else{
                return
            }
            print("---------------------------------------------------")
            NetworkManager.manager.fetchMoreNotes { notes in
                if notes.count < 8 {
                    print("======================================================")
                    self.hasMoreNotes = false
                }
                self.noteArray.append(contentsOf: notes)
              
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
        
    }
    
}

       
