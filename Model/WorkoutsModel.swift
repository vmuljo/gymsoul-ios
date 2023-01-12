//
//  UserModel.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/3/22.
//  muljo@usc.edu

import Foundation

// Model to store user information from Firebase collection "workouts"
struct WorkoutsModel : Codable {
    let workoutName: String
    let date: String
    let length: String
    let exercises: String
    let workout_id: String
    
}
