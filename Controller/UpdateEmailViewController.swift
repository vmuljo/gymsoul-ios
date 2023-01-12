//
//  EditInfoViewController.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/6/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

// View controller for updating email
class UpdateEmailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    
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
        
        emailTextField.delegate = self
        
        // Gesture recognizers for keyboard dismiss
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(userDidSingleTap(_:)))
        self.view.addGestureRecognizer(singleTap)
    }
    
    // handle email update button click, which prompts user to verify their password
    @IBAction func updateEmailClicked(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Verify Password",
        message: "Verify your password to confirm",
        preferredStyle: .alert)

        alertController.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }

        // cancel
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancel action")
        }))
        //confirm
        alertController.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { [weak alertController] (_) in
            // get the input from the password text field to pass to handleEmailUpdate function
            let passwordTextField = alertController?.textFields![0]
            print("Password: \(String(describing: passwordTextField?.text))")
            
            self.handleEmailUpdate(passwordTextField?.text ?? "")
        }))

        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // handle updating the email
    func handleEmailUpdate (_ password: String){
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: (user?.email)!, password: password)
        
        // Reauthenticate since Firebase requires it to update email
        user?.reauthenticate(with: credential, completion: { (result, error) in
            if let error {
                print(error)
                // Alert controller when there is an error with the input password
                let alertController = UIAlertController(title: "Error",
                                                        message: "Invalid password",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
            // User re-authenticated. Proceeds to update the email
                Auth.auth().currentUser?.updateEmail(to: self.emailTextField.text!){
                    error in print(error ?? "")
                }
                self.dismiss(animated: true)
              
          }
        })
    
    }
    
    // Keyboard dismiss
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @objc func userDidSingleTap(_ tap: UITapGestureRecognizer){
        emailTextField.resignFirstResponder()
    }

}
