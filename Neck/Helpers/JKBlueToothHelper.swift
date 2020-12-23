//
//  JKBlueToothHelper.swift
//  Neck
//
//  Created by 周美汝 on 2020/11/28.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit
import CoreBluetooth

enum ReceiveDataType {
    case voice
    case none
    case mono
    case loud
    case channel
    case sixChannel
    case device
    case fabaTrba
    case trba
    case playProgress
}

class JKBlueToothHelper: NSObject {
    
    static let shared = JKBlueToothHelper()
    var centralManager: CBCentralManager!
    var connectPeripheral: CBPeripheral?
    var notifyCh: CBCharacteristic?
    var data: Data?
    var deviceUpdate: ((CBPeripheral) -> Void)?
    var receiveUpdate: ((ReceiveDataType) -> Void)?
    
    
    func createCentralManager() {
        self.centralManager = CBCentralManager.init(delegate: self, queue: DispatchQueue.main)
    }
    
    func scanDevice() {
        self.centralManager.stopScan()
        self.centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    // MARK:  连接蓝牙设备
    func connectDevice(peripheral: CBPeripheral) {
        self.centralManager.connect(peripheral, options: nil)
        self.centralManager.stopScan()
    }

    // MARK:  断开蓝牙设备
    func cancelConnection() {
        guard let peripheral = JKBlueToothHelper.shared.connectPeripheral else { return }
        JKBlueToothHelper.shared.centralManager.cancelPeripheralConnection(peripheral)
        JKBlueToothHelper.shared.connectPeripheral = nil
        NotificationCenter.default.post(Notification.init(name: Notification.Name.init(NotificationNameBlueToothStateChange)))
    }
    
    // MARK:  写数据
    func writeCharacteristice(value: [UInt8]) {
        guard let characteristic = JKBlueToothHelper.shared.notifyCh else { return }
        JKBlueToothHelper.shared.connectPeripheral?.writeValue(Data(value), for: characteristic, type: .withResponse)
    }
    
    // MARK: 订阅通知
    func notifyCharacteristic(peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        peripheral.setNotifyValue(true, for: characteristic)
    }
    
    // MARK:  取消通知
    func cancelNotifyCharacteristic(peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        peripheral.setNotifyValue(false, for: characteristic)
    }
    
    // MARK:  停止扫描并断开连接
    func disconnectPeripheral(centralManager: CBCentralManager, peripheral: CBPeripheral, characteristic: CBCharacteristic) {
        self.centralManager.stopScan()
        self.centralManager.cancelPeripheralConnection(peripheral)
    }
}

extension JKBlueToothHelper: CBCentralManagerDelegate {
    // 1.4  必须实现的： //主设备状态改变的委托，在初始化CBCentralManager的适合会打开设备，只有当设备正确打开后才能使用
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unknown:
            break
        case .resetting:
            break
        case .unsupported:
            break
        case .unauthorized:
            break
        case .poweredOff:
            self.cancelConnection()
            break
        case .poweredOn:
            break
        default:
            break
        }
    }
    
    //找到外设的委托
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == nil {
            return
        }
        if let closure = JKBlueToothHelper.shared.deviceUpdate {
            closure(peripheral)
        }
//        printLog(peripheral)
    }
    
    // 连接外设成功的委托
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
//        printLog("连接成功了---\(String(describing: peripheral.name))")
        JKBlueToothHelper.shared.connectPeripheral = peripheral
        NotificationCenter.default.post(Notification.init(name: Notification.Name.init(NotificationNameBlueToothStateChange)))
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    //外设连接失败的委托
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        printLog("失败了")
    }
    //断开外设的委托
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        JKBlueToothHelper.shared.connectPeripheral = nil
        NotificationCenter.default.post(Notification.init(name: Notification.Name.init(NotificationNameBlueToothStateChange)))
        printLog("断开了")
    }
}

extension JKBlueToothHelper: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            printLog("error Discovered characteristics for \(String(describing: peripheral.name)) with error: \(String(describing: error))")
            return
        }
        if let lists = peripheral.services {
            for service in lists {
//                printLog(service.uuid)
                //扫描每个service的Characteristics，扫描到后会进入方法：didDiscoverCharacteristicsForService
//                [CBUUID.init(string: "0000fff1-0000-1000-8000-00805f9b34fb")],
                peripheral.discoverCharacteristics(nil, for: service)
//                printLog(service.uuid)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            printLog("error Discovered characteristics for \(service.uuid) with error: \(String(describing: error))")
            return
        }
        if  let lists = service.characteristics {
            for characteristic in lists {
                if characteristic.properties == .writeWithoutResponse || characteristic.properties == .write {
                    printLog(characteristic.uuid)
                }
//                printLog(characteristic.uuid.uuidString)
                if characteristic.uuid.uuidString == "FFF1" {
                    JKBlueToothHelper.shared.notifyCh = characteristic
                    peripheral.setNotifyValue(true, for: characteristic)
                }
//                printLog("service: \(service.uuid)的 Characteristic:\(characteristic.uuid)")
                //获取Characteristic的值，读到数据会进入方法: didUpdateValueForCharacteristic
                peripheral.readValue(for: characteristic)
                //搜索Characteristic的Descriptors，读到数据会进入方法： didDiscoverDescriptorsForCharacteristic
                peripheral.discoverDescriptors(for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        //打印出characteristic的UUID和值
        //!注意，value的类型是NSData，具体开发时，会根据外设协议制定的方式去解析数据
        guard let data = characteristic.value else { return }
        let bytes = [UInt8](data)
        printLog("接收数据\(bytes)")
        var type: ReceiveDataType = .none
        
        if bytes.count == 20 {
            // 固定频道
            JKSettingHelper.shared.channel1 = Int(bytes[7]) * 256 + Int(bytes[8])
            JKSettingHelper.shared.channel2 = Int(bytes[9]) * 256 + Int(bytes[10])
            JKSettingHelper.shared.channel3 = Int(bytes[11]) * 256 + Int(bytes[12])
            JKSettingHelper.shared.channel4 = Int(bytes[13]) * 256 + Int(bytes[14])
            JKSettingHelper.shared.channel5 = Int(bytes[15]) * 256 + Int(bytes[16])
            JKSettingHelper.shared.channel6 = Int(bytes[17]) * 256 + Int(bytes[18])
            type = .sixChannel
        }
        else if bytes.count == 14 {
            // FABA TRBA
            if bytes[2] == 8 && bytes[3] == 130 && bytes[4] == 15 && bytes[5] == 14 && bytes[7] == 14 && bytes[9] == 14 && bytes[11] == 14{
                JKSettingHelper.shared.faba.fa = 14 - bytes[12]
                JKSettingHelper.shared.faba.fb = bytes[10]
                JKSettingHelper.shared.trba.treble = bytes[8]
                JKSettingHelper.shared.trba.bass = bytes[6]
                type = .fabaTrba
            }
        }
        else if bytes.count == 10 {
            // 频道
            if bytes[2] == 4 && bytes[4] == 2 && bytes[5] == 0 {
                JKSettingHelper.shared.currentChannel = Int(bytes[7]) * 256 + Int(bytes[6])
                type = .channel
            }
        }
        else if bytes.count == 9 {
            // 播放进度
            if bytes[2] == 3 && bytes[3] == 133 && bytes[4] == 1 && bytes[5] == 0 {
                JKSettingHelper.shared.playProgress = Int(bytes[6])
                type = .playProgress
            }
        }
        else if bytes.count == 8 {
            // 音量
            if bytes[2] == 2 && bytes[3] == 130 && bytes[4] == 4 {
                JKSettingHelper.shared.maxVoiceValue = bytes[5]
                JKSettingHelper.shared.currentVoiceValue = bytes[6]
                type = .voice
            }
            // Device
            if bytes[2] == 2 && bytes[3] == 129 && bytes[4] == 3 && bytes[5] == 4 && bytes[6] == 2 && bytes[7] == 116 {
                JKSettingHelper.shared.deviceStatus = .bt
                type = .device
            }
            // TARA
            if bytes[2] == 2 && bytes[3] == 130 && bytes[4] == 8 && bytes[5] == 14 {
                JKSettingHelper.shared.trba.bass = bytes[6]
                type = .fabaTrba
            }
            if bytes[2] == 2 && bytes[3] == 130 && bytes[4] == 9 && bytes[5] == 14 {
                JKSettingHelper.shared.trba.treble = bytes[6]
                type = .fabaTrba
            }
        }
        else if bytes.count == 7 {
            // Mono
            if bytes[2] == 1 && bytes[3] == 130 && bytes[4] == 14 && bytes[5] <= 1{
                JKSettingHelper.shared.mono = (bytes[5] == 0)
                type = .mono
            }
            // Loud
            if bytes[2] == 1 && bytes[3] == 130 && bytes[4] == 17 && bytes[5] <= 1{
                JKSettingHelper.shared.loud = (bytes[5] == 1)
                type = .loud
            }
            // Device
            if bytes[2] == 1 && bytes[3] == 129 && bytes[4] == 3 && bytes[5] == 5 && bytes[6] == 118{
                JKSettingHelper.shared.deviceStatus = .radio
                type = .device
            }
            // Device
            if bytes[2] == 1 && bytes[3] == 129 && bytes[4] == 3 && bytes[5] == 4 && bytes[6] == 119{
                JKSettingHelper.shared.deviceStatus = .bt
                type = .device
            }
            // Device
            if bytes[2] == 1 && bytes[3] == 129 && bytes[4] == 3 && bytes[5] == 3 && bytes[6] == 120{
                JKSettingHelper.shared.deviceStatus = .aux
                type = .device
            }
            // Device
            if bytes[2] == 1 && bytes[3] == 129 && bytes[4] == 3 && bytes[5] == 2 && bytes[6] == 121{
                JKSettingHelper.shared.deviceStatus = .sd
                type = .device
            }
            // Device
            if bytes[2] == 1 && bytes[3] == 129 && bytes[4] == 3 && bytes[5] == 1 && bytes[6] == 122{
                JKSettingHelper.shared.deviceStatus = .usb
                type = .device
            }
            // trba
            if bytes[2] == 1 && bytes[3] == 130 && bytes[4] == 6{
                if bytes[5] == 0{
                    JKSettingHelper.shared.trbaType = "USER"
                }
                else if bytes[5] == 1{
                    JKSettingHelper.shared.trbaType = "POP"
                }
                else if bytes[5] == 2{
                    JKSettingHelper.shared.trbaType = "ROCK"
                }
                else if bytes[5] == 3{
                    JKSettingHelper.shared.trbaType = "JAZZ"
                }
                else if bytes[5] == 4{
                    JKSettingHelper.shared.trbaType = "CLASSIC"
                }
                else if bytes[5] == 5 {
                    JKSettingHelper.shared.trbaType = "COUNTRY"
                }
                type = .trba
            }
            // trba
            if bytes[2] == 1 && bytes[3] == 130 && bytes[4] == 5{
                if bytes[5] == 0{
                    JKSettingHelper.shared.trbaType = "USER"
                }
                else if bytes[5] == 1{
                    JKSettingHelper.shared.trbaType = "POP"
                }
                else if bytes[5] == 2{
                    JKSettingHelper.shared.trbaType = "ROCK"
                }
                else if bytes[5] == 3{
                    JKSettingHelper.shared.trbaType = "JAZZ"
                }
                else if bytes[5] == 4{
                    JKSettingHelper.shared.trbaType = "CLASSIC"
                }
                else if bytes[5] == 5 {
                    JKSettingHelper.shared.trbaType = "COUNTRY"
                }
                type = .trba
            }
        }
        if let closure = self.receiveUpdate {
            closure(type)
        }
     
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
//        printLog(characteristic.uuid)
        if characteristic.properties == .write {
            printLog("hahhhah")
        }
        if let lists = characteristic.descriptors {
            for desc in lists {
//                printLog("Descriptor uuid: \(desc.uuid)")
            }
        }

    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        printLog("didUpdateValueFor error: \(descriptor.uuid)")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error {
            printLog("错误信息：\(error)")
            return
        }
//        printLog("写入数据成功")
    }
}
