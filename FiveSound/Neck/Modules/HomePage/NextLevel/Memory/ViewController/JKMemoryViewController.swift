//
//  JKMemoryViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/11/23.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKMemoryViewController: JKViewController {

    @IBOutlet weak var btnForBack: UIButton!
    @IBOutlet weak var imgVForTitle: UIImageView!
    @IBOutlet weak var imgVForType: UIImageView!
    @IBOutlet weak var btnForFaba: UIButton!
    @IBOutlet weak var btnForSub: UIButton!
    @IBOutlet weak var btnForLoud: JKButton!
    @IBOutlet weak var btnForPrevious: UIButton!
    @IBOutlet weak var btnForPlay: UIButton!
    @IBOutlet weak var btnForNext: UIButton!
    @IBOutlet weak var btnForConnect: UIButton!
    @IBOutlet weak var btnForUser: UIButton!
    @IBOutlet weak var slider: JKSlider!
    @IBOutlet weak var labForCurrent: UILabel!
    @IBOutlet weak var labForAll: UILabel!
    @IBOutlet weak var slideForProgress: JKSlider!
    
    @IBOutlet weak var btnForPlayType: UIButton!
    private var lastTime: Int32 = 0
    private var sliderIsEditing = true
    
    private let longPress1 = UILongPressGestureRecognizer()
    private let longPress2 = UILongPressGestureRecognizer()
    
    var type: DeviceStatus = .none
        
    convenience init(type: DeviceStatus) {
        self.init()
        self.type = type
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
        self.setReceiveData()
        if self.type == .usb {
            JKSettingHelper.getUSB()
        }
        else if self.type == .sd {
            JKSettingHelper.getSDCard()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.updateUI()
        self.setAction()
    }
    
    // MARK:  setUI
    private func setUI() {
        if self.type == .usb {
            self.imgVForTitle.image = UIImage.init(named: "zt_8")
            self.imgVForType.image = UIImage.init(named: "7_icon")
        }
        else if self.type == .sd {
            self.imgVForTitle.image = UIImage.init(named: "zt_3")
            self.imgVForType.image = UIImage.init(named: "2_icon_1")
        }
        
        self.setPlayModelBtn()
        self.labForAll.text = self.formatTime(time: JKSettingHelper.shared.playAllProgress)
        self.btnForConnect.isSelected = (JKBlueToothHelper.shared.connectPeripheral != nil)
        self.slider.addTarget(self, action: #selector(valueChange), for: UIControl.Event.valueChanged)
        
        self.btnForPrevious.addGestureRecognizer(self.longPress1)
        self.btnForNext.addGestureRecognizer(self.longPress2)
        self.slideForProgress.addTarget(self, action: #selector(prograssChange), for: UIControl.Event.valueChanged)
        self.slideForProgress.addTarget(self, action: #selector(prograssIsEditEnd), for: UIControl.Event.touchUpInside)
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

        self.btnForFaba.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKFABAViewController(), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.btnForPrevious.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {element in
                JKSettingHelper.previous()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.longPress1.rx.event.subscribe(onNext: {[weak self](recognizer) in
            guard let self = self else { return }
            if Date.nowTime() - self.lastTime > 0 {
                JKSettingHelper.quickBack()
                self.lastTime = Date.nowTime()
            }
        }).disposed(by: self.disposeBag)

        self.btnForPlay.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.btnForPlay.isSelected = !self.btnForPlay.isSelected
                JKSettingHelper.playOrPause()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btnForNext.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {element in
                JKSettingHelper.next()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.longPress2.rx.event.subscribe(onNext: {[weak self](recognizer) in
            guard let self = self else { return }
            if Date.nowTime() - self.lastTime > 0 {
                JKSettingHelper.quickGo()
                self.lastTime = Date.nowTime()
            }
        }).disposed(by: self.disposeBag)
        
        self.btnForUser.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKTRBAViewController(), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btnForLoud.rx.tap.subscribe(onNext: { element in
            JKSettingHelper.setLoud(isSel: !JKSettingHelper.shared.loud)
        }).disposed(by: self.disposeBag)
        
        self.btnForPlayType.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { element in
                if JKSettingHelper.shared.playModel == "none" {
                    JKSettingHelper.setSingleCycle()
                    JKSettingHelper.shared.playModel = "rep"
                }
                else if JKSettingHelper.shared.playModel == "rep" {
                    JKSettingHelper.setRandom()
                    JKSettingHelper.shared.playModel = "rom"
                }
                else if JKSettingHelper.shared.playModel == "rom" {
                    JKSettingHelper.setCycle()
                    JKSettingHelper.shared.playModel = "none"
                }
                self.setPlayModelBtn()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

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
            else if type == .playProgress {
                if self.sliderIsEditing {
                    self.labForCurrent.text = self.formatTime(time: JKSettingHelper.shared.playProgress)
                    if JKSettingHelper.shared.playAllProgress > 0 {
                        self.slideForProgress.value = Float(JKSettingHelper.shared.playProgress) / Float(JKSettingHelper.shared.playAllProgress)
                    }
                }
            }
            else if type == .playAllProgress {
                if self.sliderIsEditing {
                    self.labForAll.text = self.formatTime(time: JKSettingHelper.shared.playAllProgress)
                    if JKSettingHelper.shared.playAllProgress > 0 {
                        self.slideForProgress.value = Float(JKSettingHelper.shared.playProgress) / Float(JKSettingHelper.shared.playAllProgress)
                    }
                }
            }
            else if type == .playStatus {
                self.btnForPlay.isSelected = JKSettingHelper.shared.playStatus
            }
            else if type == .device {
                self.jumpDeviceStatusVC()
            }
            else if type == .playModel {
                self.setPlayModelBtn()
            }
        }
    }
    
    private func setPlayModelBtn() {
        if JKSettingHelper.shared.playModel == "none" {
            self.btnForPlayType.setImage(UIImage.init(named: "music_2"), for: UIControl.State.normal)
        }
        else if JKSettingHelper.shared.playModel == "rep" {
            self.btnForPlayType.setImage(UIImage.init(named: "music_1"), for: UIControl.State.normal)
        }
        else if JKSettingHelper.shared.playModel == "rom" {
            self.btnForPlayType.setImage(UIImage.init(named: "music_3"), for: UIControl.State.normal)
        }
    }
    
    @objc func prograssChange() {
        self.sliderIsEditing = false
        self.labForCurrent.text = self.formatTime(time: Int(Float(JKSettingHelper.shared.playAllProgress) * self.slideForProgress.value))
    }
    
    @objc func prograssIsEditEnd() {
        JKSettingHelper.setPrograss(intAll: Int32(Float(JKSettingHelper.shared.playAllProgress) * self.slideForProgress.value))
        self.sliderIsEditing = true
        if !JKSettingHelper.shared.playStatus {
            JKSettingHelper.playOrPause()
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


extension JKMemoryViewController {
    func formatTime(time: Int) -> String {
        let ss = time % 60
        let mm = time / 60
        return "\(String(format: "%02d", mm)):\(String(format: "%02d", ss))"
    }
}
