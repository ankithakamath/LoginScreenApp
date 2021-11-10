//
//  ProfileController.swift
//  SideMenu
//
//  Created by Ankitha Kamath on 27/10/21.
//

import UIKit
import Photos
import FirebaseStorage
import Firebase
import FirebaseStorageUI
import FirebaseAuth

class ProfileController: UIViewController{
    
    var imagePickerController = UIImagePickerController()
    
    @IBOutlet weak var uploadedImage: UIImageView!
    
    
    
   
    @IBAction func uploadButton(_ sender: UIButton) {
    
    
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "cancel")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleDismiss))
        profileImage()
      checkPermissions()
        imagePickerController.delegate = self
    }
    
    @objc func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    func checkPermissions(){
        if PHPhotoLibrary.authorizationStatus() != PHAuthorizationStatus.authorized{
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                ()
            })
            
        }
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
        } else{
            PHPhotoLibrary.requestAuthorization(requestAuthorizationHandler)
        }
    }
    
    func requestAuthorizationHandler(status: PHAuthorizationStatus){
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized{
            print("we have access to the code")
        }else{
            print("No acess to photos")
        }
            
    }
    
    func uploadImageToCloud(fileURL: URL){
        let uid = Auth.auth().currentUser?.uid
        let storage = Storage.storage()
        //let data = Data()
        
        let storageRef = storage.reference()
        
        let localfile = fileURL
        
        let photoRef = storageRef.child(uid!)
        let uploadTask = photoRef.putFile(from: localfile, metadata: nil) { (metadata, err) in
            guard let metadata = metadata else{
                print(err?.localizedDescription)
                return
            }
            print ("photo upload")
            self.profileImage()
        }
        
    }
    func profileImage(){
        guard let uid = Auth.auth().currentUser?.uid else { return}
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let ref = storageRef.child(uid)
        ref.getData(maxSize: 5 * 1024 * 1024) { data ,error in
          if let error = error {
          }else {
            let image = UIImage(data: data!)
            DispatchQueue.main.async {
                self.uploadedImage.image = image
            }
          }
        }
      }
    }

extension ProfileController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            print(url)
            uploadImageToCloud(fileURL: url)
        }
        imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    
    
}
