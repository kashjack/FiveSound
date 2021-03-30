//
//  UserDefaults+Extension.swift
//  HomePlusTS
//
//  Created by worldunionViolet on 2019/3/18.
//  Copyright © 2019 worldunionViolet. All rights reserved.
//

import Foundation

extension UserDefaults {
    class func setDefault(key: String, value: Any?) {
        
        if value == nil {
            
            UserDefaults.standard.removeObject(forKey: key)
            
        } else {
            
            UserDefaults.standard.set(value, forKey: key)
            
            UserDefaults.standard.synchronize() //同步
            
        }
    }
    
    class func removeUserDefault(key: String?) {
        
        if key != nil {
            
            UserDefaults.standard.removeObject(forKey: key!)
            
            UserDefaults.standard.synchronize()
            
        }
    }
    
    class func getDefault(key: String) -> Any? {
        
        return UserDefaults.standard.value(forKey: key)
        
    }
}
