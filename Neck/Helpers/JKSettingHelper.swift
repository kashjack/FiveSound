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
    // 音量
    var currentVoiceAll: UInt8 = 250
    var currentVoiceValue: UInt8 = 0
    var maxVoiceValue: UInt8 = 40
    var minVoiceValue: UInt8 = 0
    //频道
    var currentChannel: Int = 0
    // Mono Loud
    var mono = false
    var loud = false
    


    // MARK:  设置音量
    class func setVoiceValue() {
        let intArr: [UInt8] = [0x55, 0xaa, 1, 2, 3, shared.currentVoiceValue, (250 - shared.currentVoiceValue)]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
    
    // MARK:  设置频道
    class func setChannel() {
        let intArr: [UInt8] = [0x55, 0xaa, 1, 3, 0x12, 1, 0xe9]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
    
    // MARK:  向上搜索频道
    class func setUpChannel() {
        let intArr: [UInt8] = [0x55, 0xaa, 1, 3, 3, 1, 0xf8]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
    
    // MARK:  向下搜索频道
    class func setDownChannel() {
        let intArr: [UInt8] = [0x55, 0xaa, 1, 3, 1, 1, 0xfa]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
    
    // MARK:  设置Mono
    class func setMono() {
        let intArr: [UInt8] = [0x55, 0xaa, 0, 2, 0xc, 0xf2]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
    
    // MARK:  设置Sub
    class func setSub() {
        let intArr: [UInt8] = [0x55, 0xaa, 1, 2, 0x12, 0, 0xeb]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
    
    // MARK:  设置Loud
    class func setLoud(isSel: Bool) {
        let intArr: [UInt8] = isSel ? [0x55, 0xaa, 1, 2, 0x10, 0, 0xed] : [0x55, 0xaa, 1, 2, 0x10, 1, 0xec]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
    
    // MARK:  设置Faba A
    class func setFabaA(value: UInt8) {
        let v: UInt8 = value
        let intArr: [UInt8] = [0x55, 0xaa, 1, 2, 0xa, 0, 0xed]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
    
    // MARK:  设置Faba B
    class func setFabaB(value: UInt8) {
        let intArr: [UInt8] = [0x55, 0xaa, 1, 2, 0xb, 0, 0xed]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
    
    
    
    
    // MARK:  获取Radio信息
    class func getRadioInfo() {
        let voiceArr: [UInt8] = [0x55, 0xaa, 0, 2, 4, 0xfa]
        JKBlueToothHelper.shared.writeCharacteristice(value: voiceArr)
        let monoArr: [UInt8] = [0x55, 0xaa, 0, 2, 0xe, 0xf0]
        JKBlueToothHelper.shared.writeCharacteristice(value: monoArr)
        let loudArr: [UInt8] = [0x55, 0xaa, 0, 2, 0x11, 0xed]
        JKBlueToothHelper.shared.writeCharacteristice(value: loudArr)
        let channelArr: [UInt8] = [0x55, 0xaa, 0, 4, 2, 0xfa]
        JKBlueToothHelper.shared.writeCharacteristice(value: channelArr)
    }
    
    // MARK:  获取Faba信息
    class func getFaBaInfo() {
        let voiceArr: [UInt8] = [0x55, 0xaa, 0, 2, 4, 0xfa]
        JKBlueToothHelper.shared.writeCharacteristice(value: voiceArr)
        let fabaArr: [UInt8] = [0x55, 0xaa, 0, 2, 0xf, 0xef]
        JKBlueToothHelper.shared.writeCharacteristice(value: fabaArr)
    }

}
