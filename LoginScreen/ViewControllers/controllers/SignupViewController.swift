//
//  SignupViewController.swift
//  LoginScreen
//
//  Created by Ankitha Kamath on 20/10/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignupViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    
    @IBOutlet weak var secondNameTextField: UITextField!
    
    
    @IBOutlet weak var userNameTextField: UITextField!
    
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        modalPresentationStyle = .fullScreen
    }
    
    func setUpElements(){
        errorLabel.alpha = 0;
    }
    
    func validateFields() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || secondNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            userNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == " " {
            
            return "Please Fill in all the fields"
        }
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedusername = userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPassword) == false {
            return "Please make sure the password contains atleast 8 charecters, a number and a special character"
        }
        else if Utilities.isUsernameValid(cleanedusername) == false{
            return "Please enter valid Mail id"
        }
        return nil
    }
    
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        let error = validateFields()
        if error != nil {
            showError(message: error!)
        }
        else {
            
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = secondNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let username = userNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().createUser(withEmail: username, password: password) {
                (result,err)in
                if err != nil {
                    
                    self.showError(message: "error creating User")
                }
                else {
                    //saving user details
                    let db = Firestore.firestore()
                    db.collection("Users").addDocument(data: ["firstname": firstName, "lastname" : lastName, "uid": result!.user.uid]) { (error) in
                        if error != nil{
                            self.showError(message: "Error! User Data Couldn't be saved")
                        }
                    }
                    //homescreen
                    self.transitionToHome()
                    
                    
                }
            }
            
        }
    }
    func showError( message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    
}

