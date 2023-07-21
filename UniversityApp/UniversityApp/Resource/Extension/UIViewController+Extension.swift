//
//  UIViewController+Extension.swift
//  UniversityApp
//
//  Created by mac on 13/07/23.
//

import UIKit

extension UIViewController {
    func showAlert(title: String? = "Error", message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        if let viewController = self.view.window?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
