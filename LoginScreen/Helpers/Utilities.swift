//
//  Utilities.swift
//  LoginScreen
//
//  Created by Ankitha Kamath on 21/10/21.
//

import Foundation
import UIKit
class Utilities {

static func isPasswordValid(_ password : String) -> Bool {
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
    return passwordTest.evaluate(with: password)
    
}
    
   
    
       static func isUsernameValid(_ username: String) -> Bool {
            let emailTest = NSPredicate(format:"SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
            return emailTest.evaluate(with: username)
        }
    
}
