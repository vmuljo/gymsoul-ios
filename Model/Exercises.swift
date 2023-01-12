//
//  Exercise.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/4/22.
//  muljo@usc.edu

import Foundation

// Model to store the initial exercises information from WGER API
struct Exercises : Decodable{
    let count: Int
    let results: [Result]
}


