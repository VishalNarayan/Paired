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
            return
        }
        let email = Auth.auth().currentUser?.email
        let usersReference = ref.child("Users").child(uid)
        let values = ["Email": email]
        
        //Updates database with user's email address
        usersReference.updateChildValues(values, withCompletionBlock: {error,ref in
            if error != nil {
                print(error?.localizedDescription)
            }
        })
        
        //If user's profile has not been set up yet, take user to SetUpProfile screen. Otherwise, display the contents of the profile.
        usersReference.observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.hasChild("Profile"){
                //Read database and load information
                self.nameLabel.text = snapshot.childSnapshot(forPath: "Profile").childSnapshot(forPath: "Name").value as! String
                self.ageLabel.text = snapshot.childSnapshot(forPath: "Profile").childSnapshot(forPath: "Birthday").value as! String
                self.genderLabel.text = snapshot.childSnapshot(forPath: "Profile").childSnapshot(forPath: "Gender").value as! String
            } else {
                //Notify user that profile hasn't been set up, segue to SetUpProfileViewController
                let alertController = UIAlertController(title: "Oops!", message: "Looks like your profile hasn't been set up yet. Let's do it!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                    self.performSegue(withIdentifier: "setUpProfile", sender: self)
                }))
                self.present(alertController, animated: true)
                
            }
        }
    }
    
    //Handles sign out
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
