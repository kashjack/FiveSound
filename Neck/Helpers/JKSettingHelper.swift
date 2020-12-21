//
//  JKSettingHelper.swift
//  Neck
//
//  Created by kashjack on 2020/12/3.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

struct FABA {
    var fa: UInt8 = 0
    var fb: UInt8 = 0
}

struct TRBA {
    var treble: UInt8 = 0
    var bass: UInt8 = 0
}

enum DeviceStatus {
    case radio
    case sd
    case usb
    case bt
    case none
    case aux
}

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
    
    // Faba
    var faba = FABA()
    
    // Trba
    var trba = TRBA()
    
    // DeviceStatus
    var deviceStatus = DeviceStatus.none
    
    // TRBAType
    var trbaType = "USER"
    
    // 固定频率
    var channel1: Int = 0
    var channel2: Int = 0
    var channel3: Int = 0
    var channel4: Int = 0
    var channel5: Int = 0
    var channel6: Int = 0
    
    // 播放进度
    var playProgress: Int = 0


    // MARK:  设置音量
    class func setVoiceValue() {
        let intArr: [UInt8] = [0x55, 0xaa, 1, 2, 3, shared.currentVoiceValue, (250 - shared.currentVoiceValue)]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
    
    // MARK:  设置模式
    class func setModel(index: UInt8) {
        let intArr: [UInt8] = [0x55, 0xaa, 1, 1, 2, index, 252 - index]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }

    // MARK:  设置固定频段
    class func setChannel(index: UInt8) {
        let intArr: [UInt8] = [0x55, 0xaa, 1, 3, 16 + index, 1, 235 - index]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
    
    // MARK:  存储固定频段
    class func setFixationChannel(index: UInt8) {
        let intArr: [UInt8] = [0x55, 0xaa, 1, 3, 16 + index, 2, 234 - index]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
        JKSettingHelper.getRadioInfo()
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
    
    // MARK:  设置Band
    class func setBand() {
        let intArr: [UInt8] = [0x55, 0xaa, 1, 3, 4, 1, 0xf7]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
        JKSettingHelper.getRadioInfo()
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
        let intArr: [UInt8] = [0x55, 0xaa, 1, 2, 0xb, value, 242 - value]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
    
    // MARK:  设置Faba B
    class func setFabaB(value: UInt8) {
        let intArr: [UInt8] = [0x55, 0xaa, 1, 2, 0xa, value, 243 - value]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
    
    // MARK:  设置Treble
    class func setTreble(value: UInt8) {
        let intArr: [UInt8] = [0x55, 0xaa, 1, 2, 9, value, 244 - value]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
    
    // MARK:  设置Bass
    class func setBass(value: UInt8) {
        let intArr: [UInt8] = [0x55, 0xaa, 1, 2, 8, value, 245 - value]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
    
    // MARK:  设置TRBA
    class func setTRBA() {
        let intArr: [UInt8] = [0x55, 0xaa, 0, 2, 5, 0xf9]
        JKBlueToothHelper.shared.writeCharacteristice(value: intArr)
    }
    
    // MARK:  获取设备信息
    class func getDeviceInfo() {
        let deviceArr: [UInt8] = [0x55, 0xaa, 0, 1, 3, 0xfc]
        JKBlueToothHelper.shared.writeCharacteristice(value: deviceArr)
    }
    
    // MARK:  获取BTMusic信息
    class func getBTMusic() {
        let voiceArr: [UInt8] = [0x55, 0xaa, 0, 2, 4, 0xfa]
        JKBlueToothHelper.shared.writeCharacteristice(value: voiceArr)
        
        let arr1: [UInt8] = [0x55, 0xaa, 1, 1, 2, 4, 0xf8]
        JKBlueToothHelper.shared.writeCharacteristice(value: arr1)
        
        let loudArr: [UInt8] = [0x55, 0xaa, 0, 2, 0x11, 0xed]
        JKBlueToothHelper.shared.writeCharacteristice(value: loudArr)
        
        let startArr: [UInt8] = [0x55, 0xaa, 0, 2, 0x13, 0xeb]
        JKBlueToothHelper.shared.writeCharacteristice(value: startArr)
    }
    
    
    // MARK:  获取Radio信息
    class func getRadioInfo() {
        let startRadioArr: [UInt8] = [0x55, 0xaa, 0, 2, 0xfa, 0xf7]
        JKBlueToothHelper.shared.writeCharacteristice(value: startRadioArr)
        let voiceArr: [UInt8] = [0x55, 0xaa, 0, 2, 4, 0xfa]
        JKBlueToothHelper.shared.writeCharacteristice(value: voiceArr)
        let startArr: [UInt8] = [0x55, 0xaa, 0, 2, 0x13, 0xeb]
        JKBlueToothHelper.shared.writeCharacteristice(value: startArr)
        let monoArr: [UInt8] = [0x55, 0xaa, 0, 2, 0xe, 0xf0]
        JKBlueToothHelper.shared.writeCharacteristice(value: monoArr)
        let loudArr: [UInt8] = [0x55, 0xaa, 0, 2, 0x11, 0xed]
        JKBlueToothHelper.shared.writeCharacteristice(value: loudArr)
        let channelArr: [UInt8] = [0x55, 0xaa, 0, 4, 2, 0xfa]
        JKBlueToothHelper.shared.writeCharacteristice(value: channelArr)
        let sixChannelArr: [UInt8] = [0x55, 0xaa, 0, 3, 0x20, 0xdd]
        JKBlueToothHelper.shared.writeCharacteristice(value: sixChannelArr)
    }
    
    // MARK:  获取Faba信息
    class func getFaBaInfo() {
        let voiceArr: [UInt8] = [0x55, 0xaa, 0, 2, 4, 0xfa]
        JKBlueToothHelper.shared.writeCharacteristice(value: voiceArr)
        let fabaTrbaArr: [UInt8] = [0x55, 0xaa, 0, 2, 0xf, 0xef]
        JKBlueToothHelper.shared.writeCharacteristice(value: fabaTrbaArr)
    }
    
    // MARK:  获取AUX信息
    class func getAUXInfo() {
        let voiceArr: [UInt8] = [0x55, 0xaa, 0, 2, 4, 0xfa]
        JKBlueToothHelper.shared.writeCharacteristice(value: voiceArr)
    }
    
    // MARK:  获取TRBA信息
    class func getTRBAInfo() {
        let voiceArr: [UInt8] = [0x55, 0xaa, 0, 2, 4, 0xfa]
        JKBlueToothHelper.shared.writeCharacteristice(value: voiceArr)
        let fabaTrbaArr: [UInt8] = [0x55, 0xaa, 0, 2, 0xf, 0xef]
        JKBlueToothHelper.shared.writeCharacteristice(value: fabaTrbaArr)
        let trbaArr: [UInt8] = [0x55, 0xaa, 0, 2, 6, 0xf8]
        JKBlueToothHelper.shared.writeCharacteristice(value: trbaArr)
    }
    
    
    
    // MARK:  上一首
    class func previous() {
        let arr: [UInt8] = [0x55, 0xaa, 1, 3, 1, 1, 0xfa]
        JKBlueToothHelper.shared.writeCharacteristice(value: arr)
    }
    
    // MARK:  下一首
    class func next() {
        let arr: [UInt8] = [0x55, 0xaa, 1, 3, 3, 1, 0xf8]
        JKBlueToothHelper.shared.writeCharacteristice(value: arr)
    }

}
