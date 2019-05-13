//
//  ProfileViewController.swift
//  PairedDating
//
//  Created by Vishal Narayan on 5/12/19.
//  Copyright © 2019 Vishal Narayan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController {
    
    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference(fromURL: "https://paireddating-29596.firebaseio.com/")
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print(Auth.auth().currentUser?.uid)
            return
        }
        let email = Auth.auth().currentUser?.email
        print(uid)
        
        let usersReference = ref.child("Users").child(uid)
        let values = ["Email": email]

        usersReference.updateChildValues(values, withCompletionBlock: {error,ref in
            if error != nil {
                print(error?.localizedDescription)
            }
        })
        //If user's profile has not been set up yet, take user to SetUpProfile screen. Otherwise, display the contents of the profile.
        usersReference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild("Profile"){
                self.nameLabel.text = snapshot.childSnapshot(forPath: "Profile").childSnapshot(forPath: "Name").value as! String
                self.ageLabel.text = snapshot.childSnapshot(forPath: "Profile").childSnapshot(forPath: "Birthday").value as! String
                self.genderLabel.text = snapshot.childSnapshot(forPath: "Profile").childSnapshot(forPath: "Gender").value as! String
                
            } else {
                print("NEEDS TO SET UP PROFILE")
                
                let alertController = UIAlertController(title: "Set Up Profile", message: "Let's set up your profile!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                    self.performSegue(withIdentifier: "setUpProfile", sender: self)
                }))
                self.present(alertController, animated: true)
                
            }
        }
    }
    
    
    
    @IBAction func signOut(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        userDefault.removeObject(forKey: "userSignedIn")
        userDefault.synchronize()
        self.performSegue(withIdentifier: "signOut", sender: self)
    }
    
}
