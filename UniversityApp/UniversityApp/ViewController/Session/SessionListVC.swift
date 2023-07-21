//
//  SessionListVC.swift
//  UniversityApp
//
//  Created by mac on 13/07/23.
//

import UIKit

class SessionListVC: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var tblSessions: UITableView!
    
    //MARK: - Local var
    
    private let userManager = UserManager.shared
    private let databaseManager = DatabaseManager.shared
    private var arrSessionList:[Session] = []
    private var arrBookingList:[Booking] = []
    private var userData:(isStudent: Bool, user: User?) = (false, nil)
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Custom func
    
    private func setupUI() {
        setupTableView()
        setupData()
    }
    
    private func setupTableView() {
        self.tblSessions.dataSource = self
        self.tblSessions.delegate = self
        self.tblSessions.separatorStyle = .none
        self.tblSessions.register(UINib(nibName: "SessionRow", bundle: nil), forCellReuseIdentifier: "SessionRow")
    }
    
    private func setupData() {
        
        if let user = userManager.getCurrentUser() {
            userData.isStudent = user.role == .student
            userData.user = user
        }
        
        if userData.isStudent {
            if let sessionList = databaseManager.getSessionsWithPendingStatus() {
                arrSessionList = sessionList
            }
        } else {
            if let deanId = userData.user?.id,
               let bookingList = self.databaseManager.getBookingsForDean(deanId) {
                self.arrBookingList = bookingList
            }
        }
        self.tblSessions.reloadData()
    }
    
    //MARK: - Action
    
    @IBAction func btnLogout(_ sender: UIButton) {
        userManager.logout()
    }
    
    @objc func bookSession(_ sender: UIButton) {
        if let sessionId = self.arrSessionList[sender.tag].id, let userId = userData.user?.id {
            
            self.databaseManager.bookSession(sessionID: sessionId, studentID: userId)
            
            self.showAlert(title: "Update", message: "Session booked with \(databaseManager.getUserByID(self.arrSessionList[sender.tag].deanId)?.name ?? "")")
            
            self.setupData()
        }
    }
    
}

// MARK: - UITableView dataSource and delegate methods

extension SessionListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        userData.isStudent ? self.arrSessionList.count : self.arrBookingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SessionRow") as? SessionRow else {
            return .init()
        }
        if userData.isStudent {
            cell.configureStudentRow(model: self.arrSessionList[indexPath.row])
        } else {
            cell.configureDeanRow(model: self.arrBookingList[indexPath.row])
        }
        cell.btnBookSession.tag = indexPath.row
        cell.btnBookSession.addTarget(self, action: #selector(self.bookSession(_:)), for: .touchUpInside)
        return cell
    }
}
