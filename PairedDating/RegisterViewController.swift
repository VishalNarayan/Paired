//
//  ViewController.swift
//  PairedDating
//
//  Created by Vishal Narayan on 5/10/19.
//  Copyright © 2019 Vishal Narayan. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController{


    let userDefault = UserDefaults.standard
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set text field colors
        emailTextField.backgroundColor = .clear
        emailTextField.tintColor = .white
        emailTextField.textColor = .white
        passwordTextField.backgroundColor = .clear
        passwordTextField.tintColor = .white
        passwordTextField.textColor = .white
        confirmPasswordTextField.backgroundColor = .clear
        confirmPasswordTextField.tintColor = .white
        confirmPasswordTextField.textColor = .white
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        if let email = emailTextField.text, let pass = passwordTextField.text, let _ = confirmPasswordTextField.text {
            if passwordTextField.text == confirmPasswordTextField.text{
                //REgister user w firebase
                Auth.auth().createUser(withEmail: email, password: pass, completion: { (user, error) in
                    if error == nil {
                        //Sends created user a verification email
                        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
                            if error == nil {
                                let alertController = UIAlertController(title: "Verify your email", message: "A verification link has been sent to your email address.", preferredStyle: .alert)
                                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (_) in
                                    self.performSegue(withIdentifier: "back", sender: self)
                                    }))
                                self.present(alertController, animated: true)
                            }
                            else {
                                print(error?.localizedDescription)}})
                        
                        //Once verification email is sent, sign out user immediately
                        do {
                            try Auth.auth().signOut()
                        } catch let signOutError as NSError {
                            print ("Error signing out: %@", signOutError)
                        }
                    }
                    else {
                        //Error: check error and show message
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alertController, animated: true)
                    }
                })
            }else {
                //Error: check error and show message
                let alertController = UIAlertController(title: "Error", message: "Passwords do not match!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alertController, animated: true)
                confirmPasswordTextField.text = ""
            }
        }
    }
    
    //Dismiss Keyboards if touched outside
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
}
