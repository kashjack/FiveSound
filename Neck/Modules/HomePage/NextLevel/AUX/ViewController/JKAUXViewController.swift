//
//  JKAUXViewController.swift
//  Neck
//
//  Created by kashjack on 2020/12/21.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKAUXViewController: JKViewController {
    
    @IBOutlet weak var btnForBack: UIButton!
    @IBOutlet weak var btnForLoud: JKButton!
    @IBOutlet weak var btnForConnect: UIButton!
    @IBOutlet weak var btnForUser: UIButton!
    @IBOutlet weak var btnForFaba: UIButton!
    @IBOutlet weak var slider: JKSlider!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setReceiveData()
        JKSettingHelper.getAUXInfo()
        self.updateUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        self.setAction()
        self.updateUI()
    }
    
    
    // MARK:  setUI
    private func setUI() {
        self.btnForConnect.isSelected = (JKBlueToothHelper.shared.connectPeripheral != nil)
        self.slider.addTarget(self, action: #selector(valueChange), for: UIControl.Event.valueChanged)
    }

    // MARK:  updateUI
    private func updateUI() {
        self.slider.maximumValue = Float(JKSettingHelper.shared.maxVoiceValue)
        self.slider.minimumValue = Float(JKSettingHelper.shared.minVoiceValue)
        self.slider.value = Float(JKSettingHelper.shared.currentVoiceValue)
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
        
        self.btnForBack.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.btnForUser.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKTRBAViewController(), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.btnForFaba.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKFABAViewController(), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.btnForLoud.rx.tap.subscribe(onNext: { element in
            JKSettingHelper.setLoud(isSel: !JKSettingHelper.shared.loud)
        }).disposed(by: self.disposeBag)
    }
    
    private func setReceiveData(){
        JKBlueToothHelper.shared.receiveUpdate = { [weak self] type in
            guard let self = self else { return }
            if type == .voice {
                self.slider.value = Float(JKSettingHelper.shared.currentVoiceValue)
            }
            else if type == .loud {
                self.btnForLoud.setButtonColor(isSelected: JKSettingHelper.shared.loud)
            }
        }
    }
    
    @objc func valueChange() {
        if JKSettingHelper.shared.currentVoiceValue == UInt8(self.slider.value) {
            return
        }
        JKSettingHelper.shared.currentVoiceValue = UInt8(self.slider.value)
        JKSettingHelper.setVoiceValue()
    }

}
