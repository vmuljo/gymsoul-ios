//
//  SuccessCreateViewController.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/3/22.
//  muljo@usc.edu

import UIKit
import FirebaseAuth

// View controller when account is successfully created
class SuccessCreateViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Sign out of newly created account once created
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }

    // return to login screen
    @IBAction func returnClicked(_ sender: UIButton) {
        // When clicked, sign out. For some reason, creating a user signs out
        self.dismiss(animated: true)
    }

}
