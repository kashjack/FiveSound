//
//  JKBlueToothHelper.swift
//  Neck
//
//  Created by 周美汝 on 2020/11/28.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit
import CoreBluetooth

class JKBlueToothHelper: NSObject {
    
    static let shared = JKBlueToothHelper()
    
    var centralManager: CBCentralManager!
    
    var connectPeripheral: CBPeripheral?

    var writeCh: CBCharacteristic?
    var notifyCh: CBCharacteristic?
    
    var data: Data?
    
    var deviceUpdate: ((CBPeripheral) -> Void)?
    
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
    
    // MARK:  写数据
    func writeCharacteristice(value: Data) {
        guard let characteristic = JKBlueToothHelper.shared.notifyCh else { return }
        printLog([UInt8](value))
        JKBlueToothHelper.shared.connectPeripheral?.writeValue(value, for: characteristic, type: .withResponse)
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
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    //外设连接失败的委托
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        printLog("失败了")
    }
    //断开外设的委托
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
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
                printLog(characteristic.uuid.uuidString)
                if characteristic.uuid.uuidString == "FF13" {
                    JKBlueToothHelper.shared.writeCh = characteristic
                }
                else if characteristic.uuid.uuidString == "FFF1" {
                    JKBlueToothHelper.shared.notifyCh = characteristic
                    peripheral.setNotifyValue(true, for: characteristic)
                }
                
                printLog("service: \(service.uuid)的 Characteristic:\(characteristic.uuid)")
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
        if let data = characteristic.value {
            let bytes = [UInt8](data)
            printLog(bytes)
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
        printLog("写入数据成功")
    }
}
