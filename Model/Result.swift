//
//  Result.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/4/22.
//  muljo@usc.edu

import Foundation

// Model to store exercise information from WGER API call to exercises
struct Result: Codable, Equatable{
    let id: Int
    let name: String
    let category: Int
}
