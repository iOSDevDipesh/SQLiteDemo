//
//  UserManager.swift
//  UniversityApp
//
//  Created by mac on 13/07/23.
//

import Foundation
import UIKit

final class UserManager {
    
    static let shared = UserManager()
    
    private let userDefaults = UserDefaults.standard
       
    private init() { }
    
    // MARK: - User Management
    
    func login(user: User) {
        UserDefaults.appSetObject(true, forKey: UserState.isLoggedIn)
        if let userData = try? JSONEncoder().encode(user) {
            userDefaults.set(userData, forKey: UserState.currentUser)
        }
    }
    
    func logout() {
        UserDefaults.removeAllValues()
        
        LoaderManager.shared.showLoader()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            LoaderManager.shared.hideLoader()
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")

            let navigationController = UINavigationController.init(rootViewController: loginVC)
            navigationController.setNavigationBarHidden(true, animated: false)
            
            UIApplication.shared.keyWindow?.rootViewController = navigationController
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
        }
    }
    
    func getCurrentUser() -> User? {
        if let userData = userDefaults.data(forKey: UserState.currentUser),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            return user
        }
        return nil
    }
    
    func isLoggedInUser() -> Bool {
        if let isLoggedIn = UserDefaults.appObjectForKey(UserState.isLoggedIn) as? Bool {
           return isLoggedIn
        }
        return false
    }
}
