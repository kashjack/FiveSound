//
//  WUPredicate.swift
//  WUKnowledge
//
//  Created by worldunionYellow on 2019/11/21.
//  Copyright © 2019 worldunionViolet. All rights reserved.
//

import UIKit

class WUPredicate: NSObject {

    // MARK: 判断是否为手机号
    class func isMobileNumber(mobile : String) -> Bool{
        let reg = "^1(3[0-9]|4[0-9]|5[0-9]|7[0-9]|8[0-9])\\d{8}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reg)
        return predicate.evaluate(with: mobile)
    }

    // MARK: 判断是否为邮箱
    class func isEmailWithReg(email: String) -> Bool {
        let reg = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reg)
        return predicate.evaluate(with: email)
    }

}
