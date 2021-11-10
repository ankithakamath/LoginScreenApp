//
//  InboxController.swift
//  SideMenu
//
//  Created by Ankitha Kamath on 27/10/21.
//

import UIKit

class InboxController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Inbox"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "cancel")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
    }
    
    @objc func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
}
    
