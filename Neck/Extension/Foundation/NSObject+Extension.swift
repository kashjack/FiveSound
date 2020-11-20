//
//  NSObject+Extension.swift
//  WUKnowledge
//
//  Created by worldunionViolet on 2019/8/23.
//  Copyright © 2019 worldunionViolet. All rights reserved.
//

import Foundation
extension NSObject{

    // MARK:返回className
    var className: String{
        get{
            let name =  type(of: self).description()
            if(name.contains(".")){
                return name.components(separatedBy: ".")[1];
            }else{
                return name
            }
            
        }
    }

    static var nameOfClass: String {
        return String(describing: self)//return nibNameOrNil
    }
    
}
