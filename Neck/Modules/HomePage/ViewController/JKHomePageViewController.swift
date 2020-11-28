//
//  JKHomePageViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/6/22.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit
import CoreBluetooth

class JKHomePageViewController: JKViewController {
    
    @IBOutlet weak var btn1: JKHomePageButton!
    @IBOutlet weak var btn2: JKHomePageButton!
    @IBOutlet weak var btn3: JKHomePageButton!
    @IBOutlet weak var btn4: JKHomePageButton!
    @IBOutlet weak var btn5: JKHomePageButton!
    
    @IBOutlet weak var btnForConnect: UIButton!
    private var dataSource = [CBPeripheral]()
    
    var manager: CBCentralManager!
    let peripherals = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setUI()
        self.setAction()
        self.manager = CBCentralManager.init(delegate: self, queue: DispatchQueue.main)
        
    }

    // MARK:  setUI
    private func setUI() {

    }


    // MARK:  setAction
    private func setAction() {
        self.btn1.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
//                self.navigationController?.pushViewController(JKMemoryViewController(), animated: true)
                if let peripheral = self.dataSource.first {
                    self.manager.connect(peripheral, options: nil)
                }else{
                    printLog("无设备")
                }
                
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn2.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKFABAViewController(), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn3.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKMemoryViewController(), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn4.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKRadioViewController(), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn5.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKMemoryViewController(), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.btnForConnect.rx.tap.subscribe(onNext: {[weak self] element in
            guard let self = self else { return }
            let vc = JKDevicesViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)

    }
    
    // MARK:  写数据
    func writeCharacteristice(peripheral: CBPeripheral, characteristic: CBCharacteristic, value: Data) {
        if characteristic.properties == .write {
            peripheral.writeValue(value, for: characteristic, type: .withResponse)
        }else{
            printLog("该字段不能写")
        }
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
        self.manager.stopScan()
        self.manager.cancelPeripheralConnection(peripheral)
    }
}

extension JKHomePageViewController: CBCentralManagerDelegate {
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
            self.manager.scanForPeripherals(withServices: nil, options: nil)
            break
        default:
            break
        }
    }
    //找到外设的委托
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if let name = peripheral.name, name == "CAR BLE" {
            self.dataSource.append(peripheral)
        }
    }
    // 连接外设成功的委托
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        printLog("连接成功了---\(String(describing: peripheral.name))")
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

extension JKHomePageViewController: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            printLog("error Discovered characteristics for \(String(describing: peripheral.name)) with error: \(String(describing: error))")
            return
        }
        if let lists = peripheral.services {
            for service in lists {
                printLog(service.uuid)
                //扫描每个service的Characteristics，扫描到后会进入方法：didDiscoverCharacteristicsForService
                peripheral.discoverCharacteristics(nil, for: service)
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
        printLog("characteristic uuid:\(characteristic.uuid)  value:\(characteristic.value ?? Data())")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        printLog(characteristic.uuid)
        if let lists = characteristic.descriptors {
            for desc in lists {
                printLog("Descriptor uuid: \(desc.uuid)")
            }
        }

    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        printLog("didUpdateValueFor error: \(descriptor.uuid)")
    }
}
