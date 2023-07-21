//
//  Session.swift
//  UniversityApp
//
//  Created by mac on 13/07/23.
//

import Foundation
import UIKit

enum SessionStatus: String, Codable {
    case pending
    case booked
}

struct Session: Codable {
    let id: Int?
    let deanId: Int
    let slotDateTime: String
    let duration: TimeInterval
    let status: SessionStatus
    
    init(id: Int? = nil, deanId: Int, slotDateTime: String, duration: TimeInterval, status: SessionStatus) {
        self.id = id
        self.deanId = deanId
        self.slotDateTime = slotDateTime
        self.duration = duration
        self.status = status
    }
}
