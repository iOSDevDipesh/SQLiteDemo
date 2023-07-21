//
//  Booking.swift
//  UniversityApp
//
//  Created by mac on 14/07/23.
//

import Foundation

struct Booking {
    let id: Int?
    let sessionId: Int
    let studentId: Int
    
    init(id: Int? = nil, sessionId: Int, studentId: Int) {
        self.id = id
        self.sessionId = sessionId
        self.studentId = studentId
    }
}
