//
//  CollectionViewCell.swift
//  LoginScreen
//
//  Created by Ankitha Kamath on 31/10/21.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
   
    
    
    @IBOutlet weak var title: UILabel!
    
    
    @IBOutlet weak var noteDescription: UILabel!
    
    
    @IBOutlet weak var dateLabel: UILabel!
    
    
    @IBOutlet weak var deleteButton: UIButton!
    
    
    var currentNote: NoteItem?
       var delegate: DeleteCellDelegate?
       
       
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
    print("+++++++++++++++++++++++++++++++++++")
    delegate?.deleteNote(note: currentNote!)
           
//    var noteArray : NoteItem? {
        
    
//    didSet{
//
//        title.text = noteArray?.title
//        noteDescription.text = noteArray?.description
//    }
//
}
}
