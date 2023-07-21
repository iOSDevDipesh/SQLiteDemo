//
//  Constant.swift
//  UniversityApp
//
//  Created by mac on 13/07/23.
//

import Foundation

struct UserState {
    static let isLoggedIn = "isLoggedIn"
    static let currentUser = "currentUser"
}

func convertDateTimeString(_ dateTimeString: String) -> (date: String, time: String)? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    if let date = dateFormatter.date(from: dateTimeString) {
        // Extracting date
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let formattedDate = dateFormatter.string(from: date)
        
        // Extracting time
        dateFormatter.dateFormat = "hh:mm a"
        let formattedTime = dateFormatter.string(from: date)
        
        return (formattedDate, formattedTime)
    }
    
    return nil
}
