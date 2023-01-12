//
//  ExerciseModel.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/4/22.
//  muljo@usc.edu

import UIKit

// Singleton model for API call to WGER to get all the exercises from the api
class ExerciseModel{
    private let BASE_URL = "https://wger.de/api/v2/"

    static let shared = ExerciseModel()
    
    var exercises = [Result]()
    var filteredExercises = [Result]()
    
    // get the exercises and return an array of results, which is exercises
    func getExercises(onSuccess: @escaping ([Result]) -> Void){
        let url = URL(string: "\(BASE_URL)/exercise/?language=2&limit=237")!
        let request = URLRequest(url: url)
        
        // Put URLRequest through a URLSesssion Task to execute the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
//                print(data)
                let decoder = JSONDecoder()
                let exercises = try decoder.decode(Exercises.self, from: data!)
                
                print("Exercises: \(exercises.count)")

                onSuccess(exercises.results)

            } catch {
                print(error)
                exit(1)
            }
            
        }
        task.resume()
    }

}


