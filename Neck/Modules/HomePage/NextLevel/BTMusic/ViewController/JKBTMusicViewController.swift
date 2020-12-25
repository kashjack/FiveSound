//
//  JKBTMusicViewController.swift
//  Neck
//
//  Created by kashjack on 2020/12/24.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKBTMusicViewController: JKViewController {

    @IBOutlet weak var btnForBack: UIButton!
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
    
    var type: DeviceStatus = .none
    var isFirstComing = true
    var isRotating = true

    
    convenience init(type: DeviceStatus) {
        self.init()
        self.type = type
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
        self.setReceiveData()
        JKSettingHelper.getBTMusic()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.updateUI()
        self.setAction()
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

        self.btnForPlay.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                if !self.btnForPlay.isSelected {
                    self.startRotate()
                }else{
                    self.pauseRotate()
                }
                self.btnForPlay.isSelected = !self.btnForPlay.isSelected
                JKSettingHelper.playOrPause()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.btnForSub.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { element in
                JKSettingHelper.setSub()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)


        self.btnForNext.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {element in
                JKSettingHelper.next()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.btnForUser.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKTRBAViewController(), animated: true)
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
            else if type == .playStatus {
                self.btnForPlay.isSelected = JKSettingHelper.shared.playStatus
                if self.isFirstComing {
                    self.startRotate()
                    if !self.btnForPlay.isSelected {
                        self.pauseRotate()
                    }
                }
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


    private func startRotate() {
        if self.isFirstComing {
            self.isFirstComing = false
            let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotateAnimation.isRemovedOnCompletion = false // 避免点击 Home 键返回,动画停止
            rotateAnimation.fromValue = 0.0
            rotateAnimation.toValue = Double.pi * 2
            rotateAnimation.duration = 20
            rotateAnimation.repeatCount = MAXFLOAT
            self.imgVForType.layer.add(rotateAnimation, forKey: nil)
        }else{
            if self.isRotating {
                return
            }
            if self.imgVForType.layer.timeOffset == 0 {
                self.startRotate()
                return
            }
            let pausedTime = self.imgVForType.layer.timeOffset
            self.imgVForType.layer.speed = 1.0
            self.imgVForType.layer.timeOffset = 5
            self.imgVForType.layer.beginTime = 0.0
            let timeWhenpause = self.imgVForType.layer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
            self.imgVForType.layer.beginTime = timeWhenpause
        }
        self.isRotating = true
    }

    func pauseRotate() {
        if !self.isRotating {
            return
        }
        let pauseTime = self.imgVForType.layer.convertTime(CACurrentMediaTime(), to: nil)
        self.imgVForType.layer.speed = 0.0
        self.imgVForType.layer.timeOffset = pauseTime
        self.isRotating = false
    }

}
