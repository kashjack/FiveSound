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
    var voiceValue: UInt8 = 0
    
    class func setVoiceValue(value : UInt8) {
        shared.voiceValue = value
        let intArr = [85, 170, 1, 2, 3, value, (250 - value)]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
}
