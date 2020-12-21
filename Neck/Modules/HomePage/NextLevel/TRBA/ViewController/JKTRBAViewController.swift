//
//  JKTRBAViewController.swift
//  Neck
//
//  Created by kashjack on 2020/12/15.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKTRBAViewController: JKViewController {
    
    @IBOutlet weak var btnForBack: UIButton!
    @IBOutlet weak var btnForConnect: UIButton!
    @IBOutlet weak var btnForType: UIButton!
    @IBOutlet weak var slider: UISlider!

    @IBOutlet weak var lab1: UILabel!
    @IBOutlet weak var lab2: UILabel!
    @IBOutlet weak var imgV1: UIImageView!
    @IBOutlet weak var imgV2: UIImageView!

    private lazy var slide1: YHSlider = {
        let yhSlide = YHSlider()
        yhSlide.titleArray = Array(0...13)
        yhSlide.backgroundColor = .clear
        return yhSlide
    }()
    
    private lazy var slide2: YHSlider = {
        let yhSlide = YHSlider()
        yhSlide.titleArray = Array(0...13)
        yhSlide.backgroundColor = .clear
        return yhSlide
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fd_interactivePopDisabled = true
        JKSettingHelper.getTRBAInfo()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        self.setAction()
        self.setReceiveData()
    }


    // MARK:  setUI
    private func setUI() {
        self.btnForConnect.isSelected = (JKBlueToothHelper.shared.connectPeripheral != nil)
        self.slider.maximumValue = Float(JKSettingHelper.shared.maxVoiceValue)
        self.slider.minimumValue = Float(JKSettingHelper.shared.minVoiceValue)
        self.slider.value = Float(JKSettingHelper.shared.currentVoiceValue)
        self.slider.addTarget(self, action: #selector(valueChange), for: UIControl.Event.valueChanged)

        self.view.addSubview(self.slide1)
        self.slide1.snp.makeConstraints { (make) in
            make.center.equalTo(self.imgV1)
            make.width.height.equalTo(150)
        }
        
        self.view.addSubview(self.slide2)
        self.slide2.snp.makeConstraints { (make) in
            make.center.equalTo(self.imgV2)
            make.width.height.equalTo(150)
        }
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
        
        self.btnForType.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {element in
                JKSettingHelper.setTRBA()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.slide1.valueChange = {[weak self] value in
            guard let self = self else { return }
            self.lab1.text = "\(Int(value + 0.5) - 7) dB"
            if JKSettingHelper.shared.trba.treble != UInt8(value + 0.5) {
                JKSettingHelper.shared.trba.treble  =  UInt8(value + 0.5)
                JKSettingHelper.setTreble(value: JKSettingHelper.shared.trba.treble)
            }
        }
        
        self.slide2.valueChange = {[weak self] value in
            guard let self = self else { return }
            self.lab2.text = "\(Int(value + 0.5) - 7) dB"
            if JKSettingHelper.shared.trba.bass != UInt8(value + 0.5) {
                JKSettingHelper.shared.trba.bass  =  UInt8(value + 0.5)
                JKSettingHelper.setBass(value: JKSettingHelper.shared.trba.bass)
            }
        }
    }
    
    private func setReceiveData(){
        JKBlueToothHelper.shared.receiveUpdate = { [weak self] type in
            guard let self = self else { return }
            if type == .voice {
                self.slider.value = Float(JKSettingHelper.shared.currentVoiceValue)
            }
            else if type == .trba {
                self.btnForType.setTitle(JKSettingHelper.shared.trbaType, for: UIControl.State.normal)
            }
            else if type == .fabaTrba {
                self.lab1.text = "\(Int(JKSettingHelper.shared.trba.treble) - 7) dB"
                self.lab2.text = "\(Int(JKSettingHelper.shared.trba.bass) - 7) dB"
                self.slide1.currentValue = Double(Int(Double(JKSettingHelper.shared.trba.treble) + 0.5)) - 0.1
                self.slide2.currentValue = Double(Int(Double(JKSettingHelper.shared.trba.bass) + 0.5)) - 0.1
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
