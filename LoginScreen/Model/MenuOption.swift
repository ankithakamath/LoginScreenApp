//
//  MenuOptions.swift
//  SideMenu
//
//  Created by Ankitha Kamath on 26/10/21.
//

import UIKit

enum MenuOption: Int,CustomStringConvertible {
    case Profile
    case Reminders
    case Settings
    case logout
    case Archives
    
    var description:String{
        switch self {
        case .Profile:
            return "Profile"
        case .Reminders:
            return "Reminders"
        case .Settings:
            return "Settings"
        case .logout:
            return "logout"
        case .Archives:
            return "Archives"
        }
    }
    var image: UIImage{
        switch self {
        case .Profile:
            return UIImage(named: "user") ?? UIImage()
        case .Reminders:
            return UIImage(named: "mail") ?? UIImage()
        case .Settings:
            return UIImage(named: "settings") ?? UIImage()
        case .logout:
            return UIImage(named: "logout") ?? UIImage()
        case .Archives:
            return UIImage(named: "arc") ?? UIImage()
        }
    }
}

