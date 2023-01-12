//
//  LoggedInViewController.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/3/22.
//  muljo@usc.edu

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CodableFirebase

// View controller for the Profile tab
class ProfileViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let user = Auth.auth().currentUser {
            // Get the document from firebase in the global thread
            DispatchQueue.global().async{
                let ref = Firestore.firestore().collection("users").document(user.uid)
                ref.getDocument{ (snapshot, error) in
                    if let snapshot {
                        let userModel = try! FirestoreDecoder().decode(UserModel.self, from: snapshot.data()!)
                        // Once the data fetched, process in main thread to update labels
                        DispatchQueue.main.async {
                            self.nameLabel.text = "\(userModel.firstName) \(userModel.lastName)"
                            self.emailLabel.text = "\(user.email!)"
                            self.view.reloadInputViews()
                        }
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // If signout button tapped
    @IBAction func signoutDidTapped(_ sender: UIButton) {
        do {
            try Auth.auth().signOut() // Signs out
            self.view.window?.rootViewController?.dismiss(animated: true, completion: nil) // Returns to root view controller
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }

    }

    // If delete button clicked
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        // Alert controller to prompt reverification to confirm delete of account
        let alertController = UIAlertController(title: "Are you sure you want to delete your account?",
        message: "Enter your login information to confirm",
        preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Password"
            textField.isSecureTextEntry = true
        }

        // cancel
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            print("Cancel action")
        }))
        //confirm: Gets email and password verification inputs
        alertController.addAction(UIAlertAction(title: "Confirm", style: .destructive, handler: { [weak alertController] (_) in
            let emailTextField = alertController?.textFields![0] // Force unwrapping because we know it exists.
            let passwordTextField = alertController?.textFields![1]
            print("Email: \(String(describing: emailTextField?.text))")
            print("Password: \(String(describing: passwordTextField?.text))")
            
            // sends text field information to handle delete
            self.handleDelete(emailTextField?.text ?? "", passwordTextField?.text ?? "")
        }))

        self.present(alertController, animated: true, completion: nil)
    }
    
    // function to handle delete of account
    func handleDelete (_ email: String, _ password: String){
        let user = Auth.auth().currentUser
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        
        // reauthenticates with passed email and password parameters
        user?.reauthenticate(with: credential, completion: { (result, error) in
            if let error {
                // if there is an error, send an alert to say invalid credentials
                print(error)
                let alertController = UIAlertController(title: "Error",
                                                        message: "Invalid credentials",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                // User re-authenticated.
                // get query from workouts collection specific to user
                let workoutsDocs = Firestore.firestore().collection("workouts").whereField("user_id", isEqualTo: user!.uid)
                
                // Get documents
                workoutsDocs.getDocuments() {
                    (query, error) in
                    if let error{
                        print("Error getting documents: \(error)")
                    } else {
                        // For each document, delete from the workouts collection
                        for document in query!.documents {
                            Firestore.firestore().collection("workouts").document(document.documentID).delete() {
                                err in
                                if let err = err {
                                    print("Error removing document: \(err)")
                                } else {
                                    print("Document successfully removed!")
                                }
                            }
                        }
                    }
                }
                
                // Delete from users collection
                Firestore.firestore().collection("users").document(user!.uid).delete(){ err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                
                // Delete user from Firebase Authentication database
                user?.delete { error in
                    if let error{
                        print("Error: \(error)")
                    }
                    else{
                        print("account deleted")
                    }
                }
                
                // Return to rootViewController (login)
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        })
    
    }
    
}
