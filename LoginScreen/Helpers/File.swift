//
//  File.swift
//  LoginScreen
//
//  Created by Ankitha Kamath on 08/11/21.
//

import Foundation
import UIKit

extension UIViewController {
func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "OK", style: .default) { (okclick) in
            
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlertWithCancel(title: String, message: String, buttonText: String, buttonAction: @escaping() -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let button = UIAlertAction(title: buttonText, style: .default) { (buttonclick) in
            buttonAction()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (cancelclick) in
        }
        
        alert.addAction(cancel)
        alert.addAction(button)
        
        self.present(alert, animated: true, completion: nil)
    }
}
