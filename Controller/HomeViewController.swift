//
//  HomeViewController.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/4/22.
//  muljo@usc.edu

import UIKit
import FirebaseFirestore
import FirebaseAuth
import CodableFirebase

// View controller for the home tab
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var recentsTableView: UITableView!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    var recentsList = [WorkoutsModel]() // gets list of recent exercises
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentsTableView.delegate = self
        recentsTableView.dataSource = self
//        self.recentsTableView.reloadData()
        // Check if logged in and fill in welcome label with users name
        if let user = Auth.auth().currentUser {
            DispatchQueue.global().async {
                do{
                    let ref = Firestore.firestore().collection("users").document(user.uid)
                    ref.getDocument{ (snapshot, error) in
                        if let snapshot {
                            let userModel = try! FirestoreDecoder().decode(UserModel.self, from: snapshot.data()!)
                            print(userModel)
                            DispatchQueue.main.async{
                                self.welcomeLabel.text = "Welcome, \(userModel.firstName) \(userModel.lastName)"
                            }
                        }
                    }
                }
            }
                    
        // gets collection of workouts from database and appends to list of recents
            DispatchQueue.global().async {
                do{
                    let recents = Firestore.firestore().collection("workouts").whereField("user_id", isEqualTo: user.uid)
                    recents.getDocuments() { (query, error) in
                        if let error{
                            print("Error getting documents: \(error)")
                        } else {
                            self.recentsList.removeAll()
                            for document in query!.documents {
                                print("Empty?")
                                let userModel = try! FirestoreDecoder().decode(WorkoutsModel.self, from: document.data())
                                print(userModel)
                                DispatchQueue.main.async{
                                    self.recentsList.append(userModel)
                                    self.recentsTableView.reloadData()
                                }
                            }
                        }
                    }
                }
            }
            
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recentsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // to display a view if empty, otherwise restore table view
        if(recentsList.count == 0){
            recentsTableView.setEmptyView(title: "No recent workouts", message: "Add a workout to display new workouts")
        }
        else{
            recentsTableView.restore()
        }
        
        return recentsList.count
    }
    
    // Have the cells fill in from the recentsList array with the workout name, length, and date
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentsCell", for: indexPath) as! RecentsTableViewCell
        
        let recent = recentsList[indexPath.row]
        cell.workoutName.text = recent.workoutName
        cell.lengthLabel.text = recent.length
        cell.dateLabel.text = recent.date
        
        return cell
    }


}
