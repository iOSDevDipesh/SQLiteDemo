//
//  UserDefaults+Extension.swift
//  UniversityApp
//
//  Created by mac on 13/07/23.
//

import Foundation

extension UserDefaults {
    
    static func appSetObject(_ object:Any, forKey:String){
        UserDefaults.standard.set(object, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
    
    static func appObjectForKey(_ strKey:String) -> Any?{
        let strValue = UserDefaults.standard.value(forKey: strKey)
        return strValue
    }
    
    static func appRemoveObjectForKey(_ strKey:String){
        UserDefaults.standard.removeObject(forKey: strKey)
        UserDefaults.standard.synchronize()
    }
    
    static func removeAllValues() {
        if let appDomain = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: appDomain)
        }
    }
}
