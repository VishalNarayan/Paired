//
//  SetUpProfileViewController.swift
//  PairedDating
//
//  Created by Vishal Narayan on 5/12/19.
//  Copyright © 2019 Vishal Narayan. All rights reserved.
//

import UIKit
import Firebase

class SetUpProfileViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var genderPicker: UIPickerView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    let userDefault = UserDefaults.standard

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            label.text = Auth.auth().currentUser?.email
        }
    }
    
    
    @IBAction func next(_ sender: UIButton) {
    }
    
    
    
    
}
