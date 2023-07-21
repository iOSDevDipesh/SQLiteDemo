//
//  DatabaseManager.swift
//  UniversityApp
//
//  Created by mac on 13/07/23.
//

import UIKit
import FMDB

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let databaseFileName = "university.sqlite"
    private var pathToDatabase: String?
    private var databaseQueue: FMDatabaseQueue?
    
    // MARK: - Tables
    
    private let userTable = "user"
    private let sessionTable = "session"
    private let bookingTable = "booking"
    
    private let field_ID = "id"
    private let field_UniversityID = "universityId"
    private let field_Name = "name"
    private let field_Password = "password"
    private let field_Role = "role"
    
    private let field_DeanID = "deanId"
    private let field_SlotDateTime = "slotDateTime"
    private let field_Duration = "duration"
    private let field_Status = "status"
    
    private let field_SessionID = "sessionId"
    private let field_StudentID = "studentId"
    
    // MARK: - Table Creation Queries
    
    private var createUserTableQuery: String {
        return "CREATE TABLE IF NOT EXISTS \(userTable) (\(field_ID) INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, \(field_UniversityID) TEXT UNIQUE, \(field_Name) TEXT, \(field_Password) TEXT, \(field_Role) TEXT)"
    }
    
    private var createSessionTableQuery: String {
        return "CREATE TABLE IF NOT EXISTS \(sessionTable) (\(field_ID) INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, \(field_DeanID) INTEGER, \(field_SlotDateTime) TEXT, \(field_Duration) INTEGER, \(field_Status) TEXT, FOREIGN KEY (\(field_DeanID)) REFERENCES \(userTable)(\(field_ID)))"
    }
    
    private var createBookingTableQuery: String {
        return "CREATE TABLE IF NOT EXISTS \(bookingTable) (\(field_ID) INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, \(field_SessionID) INTEGER, \(field_StudentID) INTEGER, FOREIGN KEY (\(field_SessionID)) REFERENCES \(sessionTable)(\(field_ID)), FOREIGN KEY (\(field_StudentID)) REFERENCES \(userTable)(\(field_ID)))"
    }
    
    private init() {
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first as NSString?
        pathToDatabase = documentsDirectory?.appendingPathComponent(databaseFileName)
        
        print(documentsDirectory ?? "")
    }
    
    func createDatabase() {
        databaseQueue = FMDatabaseQueue(path: pathToDatabase)
        
        databaseQueue?.inDatabase { database in
            if database.executeStatements(createUserTableQuery) {
                print("User table created")
            }
            if database.executeStatements(createSessionTableQuery) {
                print("Session table created")
            }
            if database.executeStatements(createBookingTableQuery) {
                print("Booking table created")
            }
        }
        
        //Temporary insert data
        setHardcodedData()
    }
    
}

// MARK: - User

extension DatabaseManager {
    
    func insertUser(_ user: User, completion: @escaping () -> Void) {
        let query = "INSERT INTO \(userTable) (\(field_UniversityID), \(field_Name), \(field_Password), \(field_Role)) VALUES (?, ?, ?, ?)"
        
        databaseQueue?.inDatabase { database in
            if database.executeUpdate(query, withArgumentsIn: [user.universityId, user.name, user.password, user.role.rawValue]) {
                print("User inserted successfully")
                completion()
            } else {
                print("Failed to insert user into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
        }
    }
    
    func getUserByUniversityID(_ universityId: String) -> User? {
        
        var user: User?
        
        let query = "SELECT * FROM \(userTable) WHERE \(field_UniversityID) = ?"
        
        databaseQueue?.inDatabase { database in
            if let resultSet = try? database.executeQuery(query, values: [universityId]), resultSet.next() {
                let id = Int(resultSet.int(forColumn: field_ID))
                let name = resultSet.string(forColumn: field_Name) ?? ""
                let password = resultSet.string(forColumn: field_Password) ?? ""
                let roleValue = resultSet.string(forColumn: field_Role) ?? ""
                
                if let role = UserRole(rawValue: roleValue) {
                    user = User(id: id, universityId: universityId, name: name, password: password, role: role)
                }
            }
        }
        
        return user
    }
    
    func getUserByID(_ userId: Int) -> User? {
        
        var user: User?
        
        let query = "SELECT * FROM \(userTable) WHERE \(field_ID) = ?"
        
        databaseQueue?.inDatabase { database in
            if let resultSet = try? database.executeQuery(query, values: [userId, UserRole.dean.rawValue]), resultSet.next() {
                if let universityId = resultSet.string(forColumn: field_UniversityID),
                   let name = resultSet.string(forColumn: field_Name),
                   let password = resultSet.string(forColumn: field_Password) {
                    user = User(id: userId, universityId: universityId, name: name, password: password, role: .dean)
                }
            }
        }
        
        return user
    }
    
}

// MARK: - Session

extension DatabaseManager {
    
    func insertSession(_ session: Session) {
        let query = "INSERT INTO \(sessionTable) (\(field_DeanID), \(field_SlotDateTime), \(field_Duration), \(field_Status)) VALUES (?, ?, ?, ?)"
        
        databaseQueue?.inDatabase { database in
            if database.executeUpdate(query, withArgumentsIn: [session.deanId, session.slotDateTime, session.duration, session.status.rawValue]) {
                print("Session inserted successfully")
            } else {
                print("Failed to insert session into the database.")
                print(database.lastError(), database.lastErrorMessage())
            }
        }
    }
    
    func getAllSessions() -> [Session]? {
        
        let query = "SELECT * FROM \(sessionTable)"
        
        var sessions: [Session] = []
        
        databaseQueue?.inDatabase { database in
            
            
            if let resultSet = try? database.executeQuery(query, values: nil) {
                while resultSet.next() {
                    let id = Int(resultSet.int(forColumn: field_ID))
                    let deanId = Int(resultSet.int(forColumn: field_DeanID))
                    let slotDateTime = resultSet.string(forColumn: field_SlotDateTime) ?? ""
                    let duration = resultSet.double(forColumn: field_Duration)
                    let statusValue = resultSet.string(forColumn: field_Status) ?? ""
                    
                    if let status = SessionStatus(rawValue: statusValue) {
                        let session = Session(id: id, deanId: deanId, slotDateTime: slotDateTime, duration: duration, status: status)
                        sessions.append(session)
                    }
                }
            }
        }
        
        return sessions.isEmpty ? nil : sessions
    }
    
    func getSessionsWithPendingStatus() -> [Session]? {
        let pendingStatus = SessionStatus.pending.rawValue
        
        let query = "SELECT * FROM \(sessionTable) WHERE \(field_Status) = ?"
        
        var sessions: [Session] = []
        
        databaseQueue?.inDatabase { database in
            if let resultSet = try? database.executeQuery(query, values: [pendingStatus]) {
                while resultSet.next() {
                    let id = Int(resultSet.int(forColumn: field_ID))
                    let deanId = Int(resultSet.int(forColumn: field_DeanID))
                    let slotDateTime = resultSet.string(forColumn: field_SlotDateTime) ?? ""
                    let duration = resultSet.double(forColumn: field_Duration)
                    let statusValue = resultSet.string(forColumn: field_Status) ?? ""
                    
                    if let status = SessionStatus(rawValue: statusValue) {
                        let session = Session(id: id, deanId: deanId, slotDateTime: slotDateTime, duration: duration, status: status)
                        sessions.append(session)
                    }
                }
            }
        }
        
        return sessions.isEmpty ? nil : sessions
    }
    
    func getSessionById(_ sessionId: Int) -> Session? {
        
        var session: Session?
        
        let query = "SELECT * FROM \(sessionTable) WHERE \(field_ID) = ?"
        
        databaseQueue?.inDatabase { database in
            
            if let resultSet = try? database.executeQuery(query, values: [sessionId]), resultSet.next() {
                let deanId = Int(resultSet.int(forColumn: field_DeanID))
                let slotDateTime = resultSet.string(forColumn: field_SlotDateTime) ?? ""
                let duration = TimeInterval(resultSet.double(forColumn: field_Duration))
                let statusValue = resultSet.string(forColumn: field_Status) ?? ""
                
                if let status = SessionStatus(rawValue: statusValue) {
                    session = Session(id: sessionId, deanId: deanId, slotDateTime: slotDateTime, duration: duration, status: status)
                }
            }
        }
        
        return session
    }
}

// MARK: - Booking

extension DatabaseManager {
    
    func bookSession(sessionID: Int, studentID: Int) {
        let updateQuery = "UPDATE \(sessionTable) SET \(field_Status) = ? WHERE \(field_ID) = ?"
        let insertQuery = "INSERT INTO \(bookingTable) (\(field_SessionID), \(field_StudentID)) VALUES (?, ?)"
        
        databaseQueue?.inDatabase { database in
            let updateSuccess = database.executeUpdate(updateQuery, withArgumentsIn: [SessionStatus.booked.rawValue, sessionID])
            if updateSuccess {
                print("Session status updated successfully")
                let insertSuccess = database.executeUpdate(insertQuery, withArgumentsIn: [sessionID, studentID])
                if insertSuccess {
                    print("Session booked successfully")
                } else {
                    print("Failed to book session.")
                    print(database.lastError(), database.lastErrorMessage())
                }
            } else {
                print("Failed to update session status.")
                print(database.lastError(), database.lastErrorMessage())
            }
        }
    }
    
    func getBookingsForDean(_ deanId: Int) -> [Booking]? {
        
        var bookings: [Booking] = []
        
        let query = """
                    SELECT \(bookingTable).\(field_ID) AS bookingId,
                    \(bookingTable).\(field_SessionID) AS sessionId, \(bookingTable).\(field_StudentID) AS studentId
                    FROM \(bookingTable)
                    JOIN \(sessionTable) ON \(bookingTable).\(field_SessionID) = \(sessionTable).\(field_ID)
                    WHERE \(sessionTable).\(field_DeanID) = ?
                """
        
        databaseQueue?.inDatabase { database in
            
            if let resultSet = try? database.executeQuery(query, values: [deanId]) {
                while resultSet.next() {
                    let bookingId = Int(resultSet.int(forColumn: "bookingId"))
                    let sessionId = Int(resultSet.int(forColumn: "sessionId"))
                    let studentId = Int(resultSet.int(forColumn: "studentId"))
                    
                    let booking = Booking(id: bookingId, sessionId: sessionId, studentId: studentId)
                    bookings.append(booking)
                }
            }
        }
        return bookings.isEmpty ? nil : bookings
    }
}

// MARK: - Hardcoded data

extension DatabaseManager {
    
    private func checkAndInsertStudents() {
        let checkStudentQuery = "SELECT COUNT(*) FROM \(userTable) WHERE \(field_Role) = ?"
        let studentRole = UserRole.student.rawValue
        
        var studentCount = 0
        
        databaseQueue?.inDatabase { database in
            if let resultSet = try? database.executeQuery(checkStudentQuery, values: [studentRole]) {
                if resultSet.next() {
                    studentCount = Int(resultSet.int(forColumnIndex: 0))
                }
            }
        }
        
        if studentCount < 2 {
            let student1 = User(universityId: "studentA", name: "Student A", password: "1234", role: .student)
            insertUser(student1) {}
            
            let student2 = User(universityId: "studentB", name: "Student B", password: "1234", role: .student)
            insertUser(student2) {}
        }
    }
    
    private func checkAndInsertDeans() {
        
        let checkDeanQuery = "SELECT COUNT(*) FROM \(userTable) WHERE \(field_Role) = ?"
        let deanRole = UserRole.dean.rawValue
        
        var deanCount = 0
        
        databaseQueue?.inDatabase { database in
            if let resultSet = try? database.executeQuery(checkDeanQuery, values: [deanRole]) {
                if resultSet.next() {
                    deanCount = Int(resultSet.int(forColumnIndex: 0))
                }
            }
        }
        
        if deanCount < 2 {
            let dean1 = User(universityId: "dean1", name: "Dean 1", password: "1234", role: .dean)
            insertUser(dean1) {}
            
            let dean2 = User(universityId: "dean2", name: "Dean 2", password: "1234", role: .dean)
            insertUser(dean2) {}
        }
    }
    
    private func createSessionsForNextTwoMonths() {
        
        guard getAllSessions() == nil else { return }
        
        let startDate = Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date()
        let endDate = Calendar.current.date(byAdding: .month, value: 2, to: startDate)!
        
        var currentDate = startDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        while currentDate <= endDate {
            if let nextThursday = Calendar.current.nextDate(after: currentDate, matching: .init(hour: 10, minute: 0, second: 0, weekday: 5), matchingPolicy: .nextTime) {
                let thursdaySlotDateTime = "\(dateFormatter.string(from: nextThursday))"
                let thursdaySession = Session(deanId: 3, slotDateTime: thursdaySlotDateTime, duration: 3600, status: .pending)
                self.insertSession(thursdaySession)
            }
            
            if let nextFriday = Calendar.current.nextDate(after: currentDate, matching: .init(hour: 10, minute: 0, second: 0, weekday: 6), matchingPolicy: .nextTime) {
                let fridaySlotDateTime = "\(dateFormatter.string(from: nextFriday))"
                let fridaySession = Session(deanId: 4, slotDateTime: fridaySlotDateTime, duration: 3600, status: .pending)
                self.insertSession(fridaySession)
            }
            
            currentDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
        }
    }
    
    private func setHardcodedData() {
        checkAndInsertStudents()
        checkAndInsertDeans()
        createSessionsForNextTwoMonths()
    }
    
}

