//
//  ViewController.swift
//  LoginScreen
//
//  Created by Ankitha Kamath on 19/10/21.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import FBSDKCoreKit

//649628057679-1jmpv55chi8pjq0bbss8ta2pt39p1vko.apps.googleusercontent.com
class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var FBButton: FBLoginButton!
    
    
    
    
    
    let signInConfig = GIDConfiguration.init(clientID: "649628057679-1jmpv55chi8pjq0bbss8ta2pt39p1vko.apps.googleusercontent.com")
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let token = AccessToken.current,
           !token.isExpired {
            
            let token = token.tokenString
            let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email,name"], tokenString: token, version: nil, httpMethod: .get)
            request.start { (connection, result, error) in
                
            }
        }
        
        else
        {
            FBButton.permissions = ["public_profile", "email"]
            FBButton.delegate = self
            
        }
        
    }
    
    @IBAction func loginButtontapped(_ sender: Any) {
        let username = userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Signing in the user
        Auth.auth().signIn(withEmail: username, password: password) { (result, error) in
            
            if error != nil {
                
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func GoogleButton(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil
            else { return }
            guard let user = user else { return }
            
            let emailAddress = user.profile?.email
            self.transitionToHome()
        }
    }
    
    
    
    func transitionToHome(){
        let setcontroller = HomeViewController()
        present(UINavigationController(rootViewController: setcontroller), animated: true, completion: nil)
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        let token = result?.token?.tokenString
        let request = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields": "email,name"], tokenString: token, version: nil, httpMethod: .get)
        request.start { (connection, result , error) in
            print("\(result)")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Log Out")
    }
    
    
}



