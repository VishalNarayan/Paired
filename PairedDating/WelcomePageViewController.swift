//
//  WelcomePageViewController.swift
//  PairedDating
//
//  Created by Vishal Narayan on 5/12/19.
//  Copyright © 2019 Vishal Narayan. All rights reserved.
//

import UIKit

class WelcomePageViewController: UIViewController {
    
    let userDefault = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "userSignedIn"){
            performSegue(withIdentifier: "profile", sender: self)
        }
    }
    
    
    @IBAction func login(_ sender: UIButton) {
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
    
    @IBAction func register(_ sender: UIButton) {
        self.performSegue(withIdentifier: "register", sender: self)
    }

}
