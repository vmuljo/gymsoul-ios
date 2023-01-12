//
//  CreateViewController.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/3/22.
//  muljo@usc.edu

import UIKit
import FirebaseFirestore
import FirebaseAuth

// View controller to create an account
class CreateViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // If user clicks the signup button:
    @IBAction func signupDidTapped(_ sender: UIButton) {
        let email = email.text!
        let password = password.text!
        let confirmPassword = confirmPassword.text!
        
        // Confirm if the password input == confirmed password input
        if(password == confirmPassword){
            Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                // Create a document in Firestore with the uid and email from Firebase Auth
                Firestore.firestore().collection("users").document(result!.user.uid).setData([
                    "firstName": self.firstName.text!, "lastName": self.lastName.text!, "email": email
                ])
                
                // If there are no errors, show the authenticated page
                if error == nil{
                    self.performSegue(withIdentifier: "createSegue", sender: nil)
                }
            }
        }
        else{ // if passwords don't match, display an alert
            let alertController = UIAlertController(title: "Passwords do not match",
            message: "",
            preferredStyle: .alert)

            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
