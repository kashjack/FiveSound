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
    @IBOutlet weak var btnForLoud: UIButton!
    @IBOutlet weak var btnForPrevious: UIButton!
    @IBOutlet weak var btnForPlay: UIButton!
    @IBOutlet weak var btnForNext: UIButton!
    @IBOutlet weak var btnForConnect: UIButton!
    @IBOutlet weak var btnForUser: UIButton!
    @IBOutlet weak var slider: JKSlider!
    @IBOutlet weak var labForCurrent: UILabel!
    @IBOutlet weak var labForAll: UILabel!
    @IBOutlet weak var slideForProgress: JKSlider!
    
    var type: DeviceStatus = .none

    
    convenience init(type: DeviceStatus) {
        self.init()
        self.type = type
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.updateUI()
        self.startRotate()
        self.setAction()
        self.setReceiveData()
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
        else if self.type == .bt{
            self.imgVForTitle.image = UIImage.init(named: "zt_2")
            self.imgVForType.image = UIImage.init(named: "1_icon_1")
            self.labForCurrent.isHidden = true
            self.labForAll.isHidden = true
            self.slideForProgress.isHidden = true
            JKSettingHelper.getBTMusic()
        }
        
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
                if self.btnForPlay.isSelected {
                    self.pauseRotate()
                }else{
                    self.resumeRotate()
                }
                self.btnForPlay.isSelected = !self.btnForPlay.isSelected
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
            JKSettingHelper.setLoud(isSel: self.btnForLoud.isSelected)
        }).disposed(by: self.disposeBag)
    }

    private func setReceiveData(){
        JKBlueToothHelper.shared.receiveUpdate = { [weak self] type in
            guard let self = self else { return }
            if type == .voice {
                self.slider.value = Float(JKSettingHelper.shared.currentVoiceValue)
            }
            else if type == .loud {
                self.btnForLoud.isSelected = JKSettingHelper.shared.loud
            }
            else if type == .playProgress {
                self.labForCurrent.text = self.formatTime(time: JKSettingHelper.shared.playProgress)
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
        // 1.创建动画
        let rotationAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        // 2.设置动画的属性
        rotationAnim.fromValue = 0
        rotationAnim.toValue = Double.pi
        rotationAnim.repeatCount = 0
        rotationAnim.duration = 5
        // 这个属性很重要 如果不设置当页面运行到后台再次进入该页面的时候 动画会停止
        rotationAnim.isRemovedOnCompletion = false
        // 3.将动画添加到layer中
        self.imgVForType.layer.add(rotationAnim, forKey: nil)
    }

    func pauseRotate() {
        let pauseTime = self.view.layer.convertTime(CACurrentMediaTime(), to: nil)
        self.view.layer.speed = 0.0
        self.view.layer.timeOffset = pauseTime
    }

    func resumeRotate() {
        let pauseTime = self.view.layer.timeOffset
        self.view.layer.speed = 1.0
        self.view.layer.timeOffset = 0.0
        self.view.layer.beginTime = 0.0
        let timeSincePause = self.view.layer.convertTime(CACurrentMediaTime(), to: nil) - pauseTime
        self.view.layer.beginTime = timeSincePause
    }

}


extension JKMemoryViewController {
    func formatTime(time: Int) -> String {
        let ss = time % 60
        let mm = time / 60
        return "\(String(format: "%02d", mm)):\(String(format: "%02d", ss))"
    }
}
