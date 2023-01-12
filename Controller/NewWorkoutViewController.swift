//
//  ViewController.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/2/22.
//  muljo@usc.edu

import UIKit
import FirebaseAuth
import FirebaseFirestore

// View controller when Add exercise button is clicked from home
// Conforms to table view delegate and text field delegate
class NewWorkoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var exerciseList = [Result]() // List of exercises added from the ExercisesViewController
    
    @IBOutlet weak var exerciseListTableView: UITableView!
    @IBOutlet weak var workoutTitleField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var lengthField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.isEnabled = false // disable save button
        
        // Set the maximum date to current date, so future dates can't be logged
        let now = Date()
        self.datePicker.maximumDate = now
        
        // Delegate initializer
        workoutTitleField.delegate = self
        lengthField.delegate = self
        exerciseListTableView.delegate = self
        exerciseListTableView.dataSource = self
        
        // Keyboard dismiss gestures
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(userDidSingleTap(_:)))
        self.view.addGestureRecognizer(singleTap)
        exerciseListTableView.reloadData() // reload data when the view loads
    }
    
    // function to add exercise to exercise list, used when exercise tapped in ExerciseViewController and receives data from there
    func addExercise(_ exercise: Result){
        exerciseList.append(exercise)
        exerciseListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Sets if no exercises in the list/ no exercises added yet, otherwise restore table view
        if(exerciseList.count == 0){
            exerciseListTableView.setEmptyView(title: "No exercises added", message: "Added exercises displayed here")
        }
        else{
            exerciseListTableView.restore()
        }
        
        return exerciseList.count
    }
    
    // Allows editing of table using swiping to delete
    // Removes from array and table view
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            exerciseList.remove(at: indexPath.row)
            exerciseListTableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }

    // Fill cells with workout information
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)

        // Configure the cell...
        let exercise = exerciseList[indexPath.row]
        print(exercise.id)
        
        cell.textLabel?.text = exercise.name
        
        // Detail text based on category
        if (exercise.category == 11){ // chest
            cell.detailTextLabel?.text = "Chest"
        }
        else if (exercise.category == 12){
            cell.detailTextLabel?.text = "Back"
        }
        else if (exercise.category == 8){
            cell.detailTextLabel?.text = "Arms"
        }
        else if (exercise.category == 13){
            cell.detailTextLabel?.text = "Shoulders"
        }
        else if (exercise.category == 9){
            cell.detailTextLabel?.text = "Legs"
        }
        else if (exercise.category == 10){
            cell.detailTextLabel?.text = "Abs"
        }
        else if (exercise.category == 15){
            cell.detailTextLabel?.text = "Cardio"
        }
        else if (exercise.category == 14){
            cell.detailTextLabel?.text = "Calves"
        }
        else{
            cell.detailTextLabel?.text = "Other"
        }

        return cell
    }
    
    // keyboard dismiss
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    // if done editing, enable save button if there is text in the workout title field
    func textFieldDidEndEditing(_ textField: UITextField) {
        saveButton.isEnabled = !workoutTitleField.text!.isEmpty
    }
    
    // If save workout clicked,
    @IBAction func saveWorkoutClicked(_ sender: UIButton) {
        if let user = Auth.auth().currentUser {
            // Encode into json and add a new document to the workouts collection
            let encoder = JSONEncoder()
            do {
                let data = try encoder.encode(self.exerciseList)
                let exercisesString = String(data: data, encoding: .utf8)!
                let workoutsRef = Firestore.firestore().collection("workouts").document()
                // fill in workout information with the workout id (so it can be used when deleting a workout), user_id (for querying), and workout information
                workoutsRef.setData([
                    "workout_id": workoutsRef.documentID,"user_id": user.uid, "workoutName": self.workoutTitleField.text!, "date": dateString(datePicker), "length": self.lengthField.text!, "exercises": exercisesString
                ])
                
                dismiss(animated: true)

                
            } catch {
                print("error \(error)")
            }
        }
    }
    
    // Keyboard dismiss
    @objc func userDidSingleTap(_ tap: UITapGestureRecognizer){
        workoutTitleField.resignFirstResponder()
        lengthField.resignFirstResponder()
    }
    
    // convert the date to a string
    func dateString(_ sender: UIDatePicker) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let strDate = dateFormatter.string(from: datePicker.date)
        return strDate
    }

}

