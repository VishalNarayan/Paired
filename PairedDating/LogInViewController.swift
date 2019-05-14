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
        //Set text field colors
        emailTextField.backgroundColor = .clear
        emailTextField.tintColor = .white
        emailTextField.textColor = .white
        passwordTextField.backgroundColor = .clear
        passwordTextField.tintColor = .white
        passwordTextField.textColor = .white
    }
    
    //Handle back button pressed
    @IBAction func back(_ sender: UIButton){
        self.performSegue(withIdentifier: "back", sender: self)
    }
    
    //Handles sign in; this function won't let the user sign in unless email has been verified.
    func signInHandler(user: AuthDataResult?, error: Error?){
        if error == nil {
            //Make sure email is verified before fully signing user in
            if Auth.auth().currentUser!.isEmailVerified {
                //User is found, go to home screen
                self.userDefault.set(true, forKey: "userSignedIn")
                self.userDefault.synchronize()
                self.performSegue(withIdentifier: "profile", sender: self)
            } else {
                //If email is not verified, immediately sign user back out and remind them to check their email.
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
            //Error: check error and show message
            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        }
    }
    
    //Handles login button pressed
    @IBAction func login(_ sender: UIButton) {
        if let email = emailTextField.text, let pass = passwordTextField.text {
            //sign in user w firebase; call sign in handler
            Auth.auth().signIn(withEmail: email, password: pass, completion: {(user, error) in
                self.signInHandler(user: user, error: error)})
        } else {
            //Error: check error and show message
            let alertController = UIAlertController(title: "Error", message: "Invalid entries!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        }
        
    }
    
    //Dismiss Keyboards if touched outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
