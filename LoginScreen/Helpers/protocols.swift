//
//  protocols.swift
//  SideMenu
//
//  Created by Ankitha Kamath on 26/10/21.
//

protocol HomecControllerDelegate{
 func handleMenuToggle(forMenuOption menuOption: MenuOption?)
    
}
protocol DeleteCellDelegate {
    func deleteNote(note: NoteItem)
}
