//
//  UserModel.swift
//  MuljoVictor_final-project
//
//  Created by Victor Muljo on 12/3/22.
//  muljo@usc.edu

import Foundation

// Model to store user information from Firebase collection "users"
struct UserModel : Codable {
    let firstName: String
    let lastName: String
    let email: String
}
