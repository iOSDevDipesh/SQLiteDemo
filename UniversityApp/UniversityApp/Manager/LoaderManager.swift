//
//  LoaderManager.swift
//  UniversityApp
//
//  Created by mac on 16/07/23.
//

import Foundation
import UIKit

final class LoaderManager {
    static let shared = LoaderManager()
    
    private let loaderView = UIView()
    
    private init() {}
    
    func showLoader() {
        DispatchQueue.main.async {
            guard let keyWindow =  UIApplication.shared.keyWindow else {
                return
            }
            self.loaderView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
            self.loaderView.frame = keyWindow.bounds
            keyWindow.addSubview(self.loaderView)
            
            let activityIndicator = UIActivityIndicatorView(style: .large)
            activityIndicator.center = self.loaderView.center
            activityIndicator.startAnimating()
            self.loaderView.addSubview(activityIndicator)
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.loaderView.removeFromSuperview()
        }
    }
}
