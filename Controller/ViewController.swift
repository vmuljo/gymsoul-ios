//
//  ViewController.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/2/22.
//  muljo@usc.edu

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        email.text = ""
        password.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        email.text = ""
        password.text = ""
        email.delegate = self
        password.delegate = self
        if Auth.auth().currentUser != nil {
            // perform segue to the home page if already logged in
            self.performSegue(withIdentifier: "mainSegue", sender: nil)
        }
        
        // tap gestures to dismiss keyboard
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(userDidSingleTap(_:)))
        self.view.addGestureRecognizer(singleTap)

    }
    
    // perform action when login button tapped
    @IBAction func loginDidTapped(_ sender: UIButton) {
        let email = email.text!
        let password = password.text!
        
        // Firebase sign in authorization function
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            // if no error and successfully signed in:
            if error == nil {
                self.performSegue(withIdentifier: "mainSegue", sender: nil)
            }
            else{ // if error occurs (either invalid email or password)
                // Alert to say login info not found "Invalid email or password. Make sure your email and password is correct."
                let alertController = UIAlertController(title: "Invalid email or password.",
                message: "Make sure your email and password are correct",
                preferredStyle: .alert)
 
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    // used to exit the view controller back to the presenting view controller (back to login screen)
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    // controls what a tap gesture does
    @objc func userDidSingleTap(_ tap: UITapGestureRecognizer){
        email.resignFirstResponder()
        password.resignFirstResponder()
    }
    
    

}

