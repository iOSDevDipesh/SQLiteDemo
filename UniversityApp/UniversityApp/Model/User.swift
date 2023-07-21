//
//  User.swift
//  UniversityApp
//
//  Created by mac on 13/07/23.
//

import Foundation
import UIKit

enum UserRole: String, Codable {
    case student
    case dean
}

struct User: Codable {
    let id: Int?
    let universityId: String
    let name: String
    let password: String
    let role: UserRole
    
    init(id: Int? = nil, universityId: String, name: String, password: String, role: UserRole) {
        self.id = id
        self.universityId = universityId
        self.name = name
        self.password = password
        self.role = role
    }
}
