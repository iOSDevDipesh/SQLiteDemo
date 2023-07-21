//
//  LoginVC.swift
//  UniversityApp
//
//  Created by mac on 13/07/23.
//

import UIKit

class LoginVC: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var txtUniversityId: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
        
    //MARK: - Local var
    
    private let databaseManager = DatabaseManager.shared
    private let userManager = UserManager.shared
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Custom func
    
    private func isValidated() -> Bool {
        guard let universityId = txtUniversityId.text, !universityId.isEmpty else {
            showAlert(message: "University ID cannot be empty")
            return false
        }
        
        guard let password = txtPassword.text, !password.isEmpty else {
            showAlert(message: "Password cannot be empty")
            return false
        }
        
        guard let user = databaseManager.getUserByUniversityID(universityId) else {
            showAlert(message: "User not found. Please register first.")
            return false
        }
        
        guard user.password == password else {
            showAlert(message: "Password mismatch.")
            return false
        }
        
        //Save data locally
        userManager.login(user: user)
        
        return true
    }
    
    //MARK: - Action
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        
        guard isValidated() else { return }
        
        LoaderManager.shared.showLoader()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        
            LoaderManager.shared.hideLoader()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let sessionListVC = storyboard.instantiateViewController(withIdentifier: "SessionListVC") as? SessionListVC {
                self.navigationController?.setNavigationBarHidden(true, animated: false)
                self.navigationController?.pushViewController(sessionListVC, animated: true)
            }
        }
    }
}
