//
//  WorkoutDetailViewController.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/5/22.
//  muljo@usc.edu

import UIKit

// View controller for the Workout detail when tapped from Workouts tab
class WorkoutDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var exercisesTableView: UITableView!
    @IBOutlet weak var workoutName: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var length: UILabel!
    
    var workout: WorkoutsModel!
    var exercises = [Result]() // exercise list to store the exercises from the workout tapped on
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Set the text to workout information
        self.workoutName.text = workout.workoutName
        self.date.text = workout.date
        self.length.text = workout.length
        self.exercisesTableView.delegate = self
        self.exercisesTableView.dataSource = self
        
        // decode the json from exercises stored in workout from Firebase (initially stored as a string)
        let string = workout.exercises
        let data = string.data(using: .utf8)!
        do {
            let exercise = try JSONDecoder().decode([Result].self, from: data)
            exercises = exercise // store decoded exercise into exercises list
        } catch {
            print(error)
        }
    }
    
    // set number of rows to exercise list count
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    // Fill in the cells with exercise information
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let exerciseCell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)

        let exercise = exercises[indexPath.row]
        exerciseCell.textLabel?.text = exercise.name
        // Detail text using category id to category name
        if (exercise.category == 11){ // chest
            exerciseCell.detailTextLabel?.text = "Chest"
        }
        else if (exercise.category == 12){
            exerciseCell.detailTextLabel?.text = "Back"
        }
        else if (exercise.category == 8){
            exerciseCell.detailTextLabel?.text = "Arms"
        }
        else if (exercise.category == 13){
            exerciseCell.detailTextLabel?.text = "Shoulders"
        }
        else if (exercise.category == 9){
            exerciseCell.detailTextLabel?.text = "Legs"
        }
        else if (exercise.category == 10){
            exerciseCell.detailTextLabel?.text = "Abs"
        }
        else if (exercise.category == 15){
            exerciseCell.detailTextLabel?.text = "Cardio"
        }
        else if (exercise.category == 14){
            exerciseCell.detailTextLabel?.text = "Calves"
        }
        else{
            exerciseCell.detailTextLabel?.text = "Other"
        }
        
        return exerciseCell
    }

}
