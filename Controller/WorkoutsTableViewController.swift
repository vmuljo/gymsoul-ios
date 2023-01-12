//
//  WorkoutsTableViewController.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/5/22.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import CodableFirebase

// View controller for Workouts tab
class WorkoutsTableViewController: UITableViewController {

    var workoutsList = [WorkoutsModel]() // List of WorkoutModel
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // gets the workouts created by each user and appends to workoutsList
        if let user = Auth.auth().currentUser {
    // gets collection of workouts from database and appends to list of workouts
            DispatchQueue.global().async {
                do{
                    let recents = Firestore.firestore().collection("workouts").whereField("user_id", isEqualTo: user.uid)
                    recents.getDocuments() { (query, error) in
                        if let error{
                            print("Error getting documents: \(error)")
                        } else {
                                self.workoutsList.removeAll()
                                for document in query!.documents {
                                    let userModel = try! FirestoreDecoder().decode(WorkoutsModel.self, from: document.data())
                                    DispatchQueue.main.async{
                                        self.workoutsList.append(userModel)
                                        self.tableView.reloadData()
                                    }
                                }
                                
//                            }
                        }
                    }
                }
            }
            
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // If no workouts in list, show empty workout view, otherwise restore table view controller
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(workoutsList.count == 0){
            tableView.setEmptyView(title: "No workouts logged", message: "Workouts will be logged here")
        }
        else{
            tableView.restore()
        }
        
        return workoutsList.count
    }

    // fill cells with workout name as main text and workout set date as detail text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workoutsCell = tableView.dequeueReusableCell(withIdentifier: "workoutsCell", for: indexPath)

        let workouts = workoutsList[indexPath.row]
        workoutsCell.textLabel?.text = workouts.workoutName
        workoutsCell.detailTextLabel?.text = workouts.date

        return workoutsCell
    }
    
    // Allow deleting using swipes
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            // want to call firebase to delete this specific workout from the database
            deleteRow(indexPath)
            // remove from workouts list and then the table view
            workoutsList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    // Prepare for segue to show the workout in more detail in the WorkoutsDetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showWorkout"{
            if let workoutVC = segue.destination as? WorkoutDetailViewController{
                print(tableView.indexPathForSelectedRow![1])
                let indexPath = tableView.indexPathForSelectedRow![1]
                workoutVC.workout = workoutsList[indexPath]
            }
        }
    }
    
    // function to delete the document from the workouts collection in Firebase
    func deleteRow(_ indexPath: IndexPath){
        let workoutDoc = Firestore.firestore().collection("workouts").document(self.workoutsList[indexPath.row].workout_id)
        workoutDoc.delete(){err in
            if err != nil{
                print("Error removing document")
            } else {
                print("Document removed")
            }
        }
    }
    

}

