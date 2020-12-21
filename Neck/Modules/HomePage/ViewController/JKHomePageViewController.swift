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


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setAction()
    }

    // MARK:  setUI
    private func setUI() {
       

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
//                if JKBlueToothHelper.shared.connectPeripheral == nil {
//                    WULoadingView.show("Bluetooth Disconnected")
//                    return
//                }
                JKSettingHelper.setModel(index: 3)
                self.navigationController?.pushViewController(JKAUXViewController(), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn2.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
//                if JKBlueToothHelper.shared.connectPeripheral == nil {
//                    WULoadingView.show("Bluetooth Disconnected")
//                    return
//                }
                JKSettingHelper.setModel(index: 4)
                self.navigationController?.pushViewController(JKMemoryViewController(type: .bt), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn3.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
//                if JKBlueToothHelper.shared.connectPeripheral == nil {
//                    WULoadingView.show("Bluetooth Disconnected")
//                    return
//                }
                JKSettingHelper.setModel(index: 1)
                self.navigationController?.pushViewController(JKMemoryViewController(type: .usb), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn4.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
//                if JKBlueToothHelper.shared.connectPeripheral == nil {
//                    WULoadingView.show("Bluetooth Disconnected")
//                    return
//                }
                JKSettingHelper.setModel(index: 5)
                self.navigationController?.pushViewController(JKRadioViewController(), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn5.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
//                if JKBlueToothHelper.shared.connectPeripheral == nil {
//                    WULoadingView.show("Bluetooth Disconnected")
//                    return
//                }
                JKSettingHelper.setModel(index: 2)
                self.navigationController?.pushViewController(JKMemoryViewController(type: .sd), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.btnForConnect.rx.tap.subscribe(onNext: {[weak self] element in
            guard let self = self else { return }
            let vc = JKDevicesViewController()
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)

    }
    
}

