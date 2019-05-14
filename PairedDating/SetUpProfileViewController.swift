//
//  SetUpProfileViewController.swift
//  PairedDating
//
//  Created by Vishal Narayan on 5/12/19.
//  Copyright © 2019 Vishal Narayan. All rights reserved.
//

import UIKit
import Firebase

class SetUpProfileViewController: UIViewController{
    
    let userDefault = UserDefaults.standard
    
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var genderTextField: UITextField!
    
    @IBOutlet weak var nextButton: UIButton!
    
    var genders = ["Female", "Male", "Other"]
    var gender = "Female"
    
    //Called when genderTextField is being edited
    @objc func genderChanged() {
        if genderTextField.text != nil {
            gender = genderTextField.text!
            genders[genders.count-1] = gender
            genderPicker.reloadAllComponents()
            print("hereeerer\n")
        }
        else {
            gender = "Other"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set text field colors
        fullNameTextField.backgroundColor = .clear
        fullNameTextField.tintColor = .white
        fullNameTextField.textColor = .white
        genderTextField.backgroundColor = .clear
        genderTextField.tintColor = .clear
        genderTextField.textColor = .clear
        datePicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        genderPicker.dataSource = self
        genderPicker.delegate = self
        genderTextField.isHidden = true
        
        genderTextField.addTarget(self, action: Selector("genderChanged"), for: .editingChanged)
    }
    
    
    @IBAction func next(_ sender: UIButton) {
        if fullNameTextField.text != "" {
            //Upload info to database and take user to profile screen
            let name = fullNameTextField.text!
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM dd, YYYY"
            let date = formatter.string(from: datePicker.date)
            
            //Sends user an alert to confirm entries
            let alertController = UIAlertController(title: "\nConfirm?\n\n", message: "Name: \(name)\n\n" + "Birthday: \(date)\n\n" + "Gender: \(gender)\n", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
                self.updateProfileHandler(name: name, date: date, gender: self.gender)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alertController, animated: true)

        }else {
            
            let alertController = UIAlertController(title: "Error", message: "Please enter your full name.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self.present(alertController, animated: true)
        }
    }
    
    //Dismiss Keyboards if touched outside; also if Gender Field is empty, make some updates
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fullNameTextField.resignFirstResponder()
        genderTextField.resignFirstResponder()
        if genderTextField.text == "" {
            genderPicker.selectRow(1, inComponent: 0, animated: true)
            genderTextField.isHidden = true
            genders[genders.count-1] = "Other"
            gender = genders[1]
            genderPicker.reloadAllComponents()
        }
    }
    
    //Called if user entries are confirmed
    func updateProfileHandler (name: String, date: String, gender: String) {
        let ref = Database.database().reference(fromURL: "https://paireddating-29596.firebaseio.com/")
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let usersReference = ref.child("Users").child(uid).child("Profile")
        let values = ["Name": name, "Birthday": date, "Gender": gender]
        
        //Load user profile info into database
        usersReference.updateChildValues(values, withCompletionBlock: {error,ref in
            if error != nil {
            print(error?.localizedDescription)
            }})
        self.performSegue(withIdentifier: "profileDone", sender: self)
    }
}

//Extension defines attributes about the Gender PickerView
extension SetUpProfileViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genders[row]
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genders.count
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.textAlignment = .center
            pickerLabel?.textColor = .white
        }
        pickerLabel?.font = UIFont(name: "<Your Font Name>", size: 30)
        pickerLabel?.text = genders[row]
        pickerLabel?.textColor = UIColor.white
        
        return pickerLabel!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row == genders.count-1 {
            genderTextField.isHidden = false
            genderTextField.becomeFirstResponder()
            genderChanged()
        } else {
            genders[genders.count-1] = "Other"
            genderPicker.reloadAllComponents()
            genderTextField.resignFirstResponder()
            genderTextField.isHidden = true
            gender = genders[row]
        }
    }
}
