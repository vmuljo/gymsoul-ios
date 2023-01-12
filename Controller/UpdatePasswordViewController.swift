//
//  UpdatePasswordViewController.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/6/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

// View controller for updating password
class UpdatePasswordViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var currentPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var confirmNewPasswordField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presentingViewController?.viewWillDisappear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presentingViewController?.viewWillAppear(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        currentPasswordField.delegate = self
        newPasswordField.delegate = self
        currentPasswordField.delegate = self
        // Do any additional setup after loading the view.
        
        // gesture recognizers
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(userDidSingleTap(_:)))
        self.view.addGestureRecognizer(singleTap)
    }
    
    // Password button click, update the password after reathenticating
    @IBAction func updatePasswordClicked(_ sender: UIButton) {
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: self.currentPasswordField.text!)
        
        user?.reauthenticate(with: credential, completion: { (result, error) in
            if let error {
                // error if invalid authentication
                print(error)
                let alertController = UIAlertController(title: "Error",
                                                        message: "Invalid current password",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                // User re-authenticated.
                // Check if new password == confirmed new password and then update
                if(self.newPasswordField.text == self.confirmNewPasswordField.text){
                    Auth.auth().currentUser?.updatePassword(to: self.newPasswordField.text!) { error in
                        print(error ?? "")
                    }
                    self.dismiss(animated: true)
                }
                else{ // If mismatched passwords, alert that passwords dont match
                    let alertController = UIAlertController(title: "Passwords do not match",
                    message: "",
                    preferredStyle: .alert)

                    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                    
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }
        })
    }

    // Keyboard dismiss
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    
    @objc func userDidSingleTap(_ tap: UITapGestureRecognizer){
        currentPasswordField.resignFirstResponder()
        newPasswordField.resignFirstResponder()
        confirmNewPasswordField.resignFirstResponder()
    }
}
