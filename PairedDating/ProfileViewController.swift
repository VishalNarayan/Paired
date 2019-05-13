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
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ref = Database.database().reference(fromURL: "https://paireddating-29596.firebaseio.com/")
        print("here")
        let values = ["name": "Alexa", "email": "alexa@hotmail.com"]
        ref.updateChildValues(values, withCompletionBlock: {error,ref in
            if error != nil {
                print(error?.localizedDescription)
            }
        })
        
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
