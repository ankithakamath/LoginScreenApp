//
//  ContainerController.swift
//  SideMenu
//
//  Created by Ankitha Kamath on 26/10/21.
//

import UIKit
import GoogleSignIn

class ContainerController: UIViewController {
    
    
    
    var menuController:MenuController!
    var centerController: UIViewController!
    var isExpanded = false
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return.lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool{
        return isExpanded
    }
    
    func configureHomeController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        // let homeController = HomeViewController()
        centerController = UINavigationController(rootViewController: homeVC)
        homeVC.delegate = self
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
        
    }
    
    func presentLoginScreen(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: Constants.Storyboard.loginViewController) as! LoginViewController
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
        
    }
    
    func configureMenuController(){
        
        if menuController == nil{
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
            
        }
    }
    
    func Signout(){
        
        do{
            //try Auth.auth().signOut()
            GIDSignIn.sharedInstance.signOut()
            presentLoginScreen()
        } catch {
            
            print("Error in signing out")
        }
    }
    
    func animatePanel(shouldExpand: Bool, menuOption: MenuOption?){
        
        if shouldExpand {
            //method to shoemenu
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 80
            }, completion: nil)
        }else{
            //method to hide menu
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                self.centerController.view.frame.origin.x = 0
            }) { (_) in
                guard let menuOption = menuOption else {
                    return
                }
                
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
        animateStatusbar()
    }
    
    func didSelectMenuOption(menuOption: MenuOption){
        
        switch menuOption{
            
        case .Profile:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
            let navVC = UINavigationController(rootViewController: profileVC)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true, completion: nil)
            
            
        case .Reminders:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let reminderVC = storyboard.instantiateViewController(withIdentifier: "ReminderController") as! ReminderController
            let navVC = UINavigationController(rootViewController: reminderVC)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true, completion: nil)
            
        case .Settings:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let settingsVC = storyboard.instantiateViewController(withIdentifier: "SettingsController") as! SettingsController
            let navVC = UINavigationController(rootViewController: settingsVC)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true, completion: nil)
            
        case .logout:
            Signout()
            
        case .Archives:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let archiveVC = storyboard.instantiateViewController(withIdentifier: "ArchivesController") as! ArchivesController
            let navVC = UINavigationController(rootViewController: archiveVC)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true, completion: nil)
            
        }
    }
    
    func animateStatusbar(){
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
}

extension ContainerController: HomecControllerDelegate{
    func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        
        if !isExpanded{
            configureMenuController()
        }
        //toggle between true and false
        isExpanded = !isExpanded
        animatePanel(shouldExpand: isExpanded, menuOption: menuOption)
        
    }
}



