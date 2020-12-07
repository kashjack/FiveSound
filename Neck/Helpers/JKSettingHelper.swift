//
//  JKSettingHelper.swift
//  Neck
//
//  Created by kashjack on 2020/12/3.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKSettingHelper: NSObject {
    
    static let shared = JKSettingHelper()
    var currentVoiceValue: UInt8 = 0
    var maxVoiceValue: UInt8 = 40
    var minVoiceValue: UInt8 = 0
    
    class func setVoiceValue() {
        let intArr = [85, 170, 1, 2, 3, shared.currentVoiceValue, (250 - shared.currentVoiceValue)]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
}
