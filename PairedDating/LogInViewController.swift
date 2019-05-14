//
//  LogInViewController.swift
//  PairedDating
//
//  Created by Vishal Narayan on 5/12/19.
//  Copyright © 2019 Vishal Narayan. All rights reserved.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.backgroundColor = .clear
        emailTextField.tintColor = .white
        emailTextField.textColor = .white
        passwordTextField.backgroundColor = .clear
        passwordTextField.tintColor = .white
        passwordTextField.textColor = .white
    }
    
    @IBAction func back(_ sender: UIButton){
        self.performSegue(withIdentifier: "back", sender: self)
    }
    
    func signInHandler(user: AuthDataResult?, error: Error?){
        if error == nil {
            //Make sure email is verified before fully signing user in
            if Auth.auth().currentUser!.isEmailVerified {
                //user is found, go to home screen
                self.userDefault.set(true, forKey: "userSignedIn")
                self.userDefault.synchronize()
                print()
                self.performSegue(withIdentifier: "profile", sender: self)
            } else {
                do {
                    try Auth.auth().signOut()
                    let alertController = UIAlertController(title: "Verify Email", message: "Please verify your email address.", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                    self.present(alertController, animated: true)
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            }
        }
        else {
            //Error, check error and show message
            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        if let email = emailTextField.text, let pass = passwordTextField.text {
            //sign in user w firebase
            Auth.auth().signIn(withEmail: email, password: pass, completion: {(user, error) in
                self.signInHandler(user: user, error: error)})
        } else {
            //Error: check error and show message
            let alertController = UIAlertController(title: "Error", message: "Invalid entries!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //Dismiss keyboard
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    
}



