//
//  SessionRow.swift
//  UniversityApp
//
//  Created by mac on 13/07/23.
//

import UIKit

class SessionRow: UITableViewCell {

    //MARK: - Outlets
    
    @IBOutlet weak var lblUserTitle: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblSessionDate: UILabel!
    @IBOutlet weak var lblSessionTime: UILabel!
    @IBOutlet weak var lblSessionDuration: UILabel!
    @IBOutlet weak var lblSessionStatus: UILabel!
    @IBOutlet weak var btnBookSession: UIButton!
    
    //MARK: - Local var
    
    private let databaseManager = DatabaseManager.shared
    
    //MARK: - awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    //MARK: - Custom func
    
    func configureStudentRow(model: Session) {
        configureRow(with: "Dean name : ", userName: self.databaseManager.getUserByID(model.deanId)?.name, session: model)
    }
    
    func configureDeanRow(model: Booking) {
        guard let student = self.databaseManager.getUserByID(model.studentId),
              let session = self.databaseManager.getSessionById(model.sessionId) else {
            return
        }
        configureRow(with: "Student name : ", userName: student.name, session: session)
    }
    
    private func configureRow(with title: String, userName: String?, session: Session) {
        self.lblUserTitle.text = title
        self.lblUserName.text = userName
        
        self.lblSessionDate.text = convertDateTimeString("\(session.slotDateTime)")?.date
        self.lblSessionTime.text = convertDateTimeString("\(session.slotDateTime)")?.time
        
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.hour]
        self.lblSessionDuration.text = formatter.string(from: session.duration)
        
        self.lblSessionStatus.textColor = (session.status == .pending) ? .green : .red
        self.lblSessionStatus.text = session.status.rawValue.capitalized
        self.btnBookSession.isHidden = (session.status == .booked)
    }
}
