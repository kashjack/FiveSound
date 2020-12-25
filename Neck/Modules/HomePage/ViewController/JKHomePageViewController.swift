//
//  JKHomePageViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/6/22.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKHomePageViewController: JKViewController {
    
    @IBOutlet weak var btn1: JKHomePageButton!
    @IBOutlet weak var btn2: JKHomePageButton!
    @IBOutlet weak var btn3: JKHomePageButton!
    @IBOutlet weak var btn4: JKHomePageButton!
    @IBOutlet weak var btn5: JKHomePageButton!
    
    @IBOutlet weak var btnForConnect: UIButton!
    
    private var index: UInt8 = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setReceiveData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setAction()
    }

    // MARK:  setUI
    private func setUI() {
        JKBlueToothHelper.shared.setCallStatus()
    }


    // MARK:  setAction
    private func setAction() {
        // MARK:  蓝牙连接状态变化
        NotificationCenter.default.rx.notification(Notification.Name.init(NotificationNameBlueToothStateChange)).subscribe(onNext: {[weak self](notification) in
            guard let self = self else { return }
            self.btnForConnect.isSelected = (JKBlueToothHelper.shared.connectPeripheral != nil)
            if JKBlueToothHelper.shared.connectPeripheral == nil {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
                
        self.btn1.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                if JKBlueToothHelper.shared.isConnect() && JKBlueToothHelper.shared.callType == .Disconnected {
                    JKSettingHelper.setModel(index: 3)
                    self.navigationController?.pushViewController(JKAUXViewController(), animated: true)
                }else{
                    if JKBlueToothHelper.shared.callType != .Disconnected {
                        WULoadingView.show("The phone is in a call")
                    }else{
                        WULoadingView.show("Bluetooth Disconnected")
                    }
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn2.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKBTMusicViewController(), animated: true)
                return

                if JKBlueToothHelper.shared.isConnect() && JKBlueToothHelper.shared.callType == .Disconnected {
                    JKSettingHelper.setModel(index: 4)
                    self.navigationController?.pushViewController(JKBTMusicViewController(), animated: true)
                }else{
                    if JKBlueToothHelper.shared.callType != .Disconnected {
                        WULoadingView.show("The phone is in a call")
                    }else{
                        WULoadingView.show("Bluetooth Disconnected")
                    }
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn3.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { element in
                if JKBlueToothHelper.shared.isConnect() && JKBlueToothHelper.shared.callType == .Disconnected {
                    JKSettingHelper.setModel(index: 1)
                }else{
                    if JKBlueToothHelper.shared.callType != .Disconnected {
                        WULoadingView.show("The phone is in a call")
                    }else{
                        WULoadingView.show("Bluetooth Disconnected")
                    }
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn4.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                if JKBlueToothHelper.shared.isConnect() && JKBlueToothHelper.shared.callType == .Disconnected {
                    JKSettingHelper.setModel(index: 5)
                    self.navigationController?.pushViewController(JKRadioViewController(), animated: true)
                }else{
                    if JKBlueToothHelper.shared.callType != .Disconnected {
                        WULoadingView.show("The phone is in a call")
                    }else{
                        WULoadingView.show("Bluetooth Disconnected")
                    }
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn5.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { element in
                if JKBlueToothHelper.shared.isConnect() && JKBlueToothHelper.shared.callType == .Disconnected {
                    JKSettingHelper.setModel(index: 2)
                }else{
                    if JKBlueToothHelper.shared.callType != .Disconnected {
                        WULoadingView.show("The phone is in a call")
                    }else{
                        WULoadingView.show("Bluetooth Disconnected")
                    }
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.btnForConnect.rx.tap.subscribe(onNext: {[weak self] element in
            guard let self = self else { return }
            let vc = JKDevicesViewController()
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)

    }
    
    func setReceiveData() {
        JKBlueToothHelper.shared.receiveUpdate = { [weak self] type in
            guard let self = self else { return }
            if type == .device {
                if JKSettingHelper.shared.deviceStatus == .usb || JKSettingHelper.shared.deviceStatus == .sd{
                    self.navigationController?.pushViewController(JKMemoryViewController.init(type: JKSettingHelper.shared.deviceStatus), animated: true)
                }
            }

        }
    }
    
    
}

