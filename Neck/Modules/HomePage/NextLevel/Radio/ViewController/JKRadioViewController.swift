//
//  JKRadioViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/11/23.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit
import AVFoundation

class JKRadioViewController: JKViewController {

    @IBOutlet weak var btnForBack: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btnForFaba: UIButton!
    @IBOutlet weak var btnForUp: UIButton!
    @IBOutlet weak var btnForDown: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnForMono: UIButton!
    @IBOutlet weak var btnForBand: UIButton!
    @IBOutlet weak var btnForSub: UIButton!
    @IBOutlet weak var btnForLoud: UIButton!
    @IBOutlet weak var btnForConnect: UIButton!
    @IBOutlet weak var btnForUser: UIButton!
    
    private let longPress1 = UILongPressGestureRecognizer()
    private let longPress2 = UILongPressGestureRecognizer()
    private let longPress3 = UILongPressGestureRecognizer()
    private let longPress4 = UILongPressGestureRecognizer()
    private let longPress5 = UILongPressGestureRecognizer()
    private let longPress6 = UILongPressGestureRecognizer()

    @IBOutlet weak var labForChannel: UILabel!
    private lazy var slideView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainColor
        return view
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JKSettingHelper.getRadioInfo()
        self.updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        self.updateUI()
        self.setAction()
        self.setReceiveData()
    }
    
    // MARK:  setUI
    private func setUI() {
        self.btnForConnect.isSelected = (JKBlueToothHelper.shared.connectPeripheral != nil)

        self.slider.addTarget(self, action: #selector(valueChange), for: UIControl.Event.valueChanged)
        
        self.backView.addSubview(self.slideView)
        self.slideView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(10)
            make.height.equalTo(40)
        }
        
        self.btn1.addGestureRecognizer(self.longPress1)
        self.btn2.addGestureRecognizer(self.longPress2)
        self.btn3.addGestureRecognizer(self.longPress3)
        self.btn4.addGestureRecognizer(self.longPress4)
        self.btn5.addGestureRecognizer(self.longPress5)
        self.btn6.addGestureRecognizer(self.longPress6)
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

        self.btn1.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                JKSettingHelper.setChannel(index: 1)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.longPress1.rx.event.subscribe(onNext: { [weak self] (recognizer) in
            guard let self = self else { return }
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.longPress1.state = .ended
            JKSettingHelper.setFixationChannel(index: 1)
        }).disposed(by: self.disposeBag)
        
        self.btn2.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                JKSettingHelper.setChannel(index: 2)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.longPress2.rx.event.subscribe(onNext: { [weak self] (recognizer) in
            guard let self = self else { return }
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.longPress2.state = .ended
            JKSettingHelper.setFixationChannel(index: 2)
        }).disposed(by: self.disposeBag)
        
        
        self.btn3.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                JKSettingHelper.setChannel(index: 3)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.longPress3.rx.event.subscribe(onNext: { [weak self] (recognizer) in
            guard let self = self else { return }
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.longPress3.state = .ended
            JKSettingHelper.setFixationChannel(index: 3)
        }).disposed(by: self.disposeBag)
        
        self.btn4.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                JKSettingHelper.setChannel(index: 4)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.longPress4.rx.event.subscribe(onNext: { [weak self] (recognizer) in
            guard let self = self else { return }
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.longPress4.state = .ended
            JKSettingHelper.setFixationChannel(index: 4)
        }).disposed(by: self.disposeBag)
        
        self.btn5.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                JKSettingHelper.setChannel(index: 5)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.longPress5.rx.event.subscribe(onNext: { [weak self] (recognizer) in
            guard let self = self else { return }
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.longPress5.state = .ended
            JKSettingHelper.setFixationChannel(index: 5)
        }).disposed(by: self.disposeBag)
        
        self.btn6.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                JKSettingHelper.setChannel(index: 6)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.longPress6.rx.event.subscribe(onNext: { [weak self] (recognizer) in
            guard let self = self else { return }
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            self.longPress6.state = .ended
            JKSettingHelper.setFixationChannel(index: 6)
        }).disposed(by: self.disposeBag)
        
        self.btnForMono.rx.tap.subscribe(onNext: { element in
            JKSettingHelper.setMono()
        }).disposed(by: self.disposeBag)
        
        self.btnForBand.rx.tap.subscribe(onNext: { element in
            JKSettingHelper.setBand()
        }).disposed(by: self.disposeBag)
        
        self.btnForSub.rx.tap.subscribe(onNext: { element in
            JKSettingHelper.setSub()
        }).disposed(by: self.disposeBag)
        
        self.btnForLoud.rx.tap.subscribe(onNext: { element in
            JKSettingHelper.setLoud(isSel: self.btnForLoud.isSelected)
        }).disposed(by: self.disposeBag)
                
        self.btnForUp.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                JKSettingHelper.setUpChannel()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btnForDown.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {
                JKSettingHelper.setDownChannel()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.btnForUser.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKTRBAViewController(), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
    }

    
    
    @objc func valueChange() {
        if JKSettingHelper.shared.currentVoiceValue == UInt8(self.slider.value) {
            return
        }
        JKSettingHelper.shared.currentVoiceValue = UInt8(self.slider.value)
        JKSettingHelper.setVoiceValue()
    }
    
    private func setReceiveData(){
        JKBlueToothHelper.shared.receiveUpdate = { [weak self] type in
            guard let self = self else { return }
            if type == .voice {
                self.slider.value = Float(JKSettingHelper.shared.currentVoiceValue)
            }
            else if type == .mono {
                self.btnForMono.isSelected = JKSettingHelper.shared.mono
            }
            else if type == .loud {
                self.btnForLoud.isSelected = JKSettingHelper.shared.loud
            }
            else if type == .channel {
                self.labForChannel.text = String(format: "%.1f", Double(JKSettingHelper.shared.currentChannel) / 100)
                let distance = CGFloat(JKSettingHelper.shared.currentChannel - 8700) / 10.0
                self.slideView.snp.updateConstraints { (make) in
                    make.left.equalToSuperview().offset(distance)
                }
            }
            else if type == .sixChannel {
                self.btn1.setTitle(String(format: "%.1f", Double(JKSettingHelper.shared.channel1) / 100), for: UIControl.State.normal)
                self.btn2.setTitle(String(format: "%.1f", Double(JKSettingHelper.shared.channel2) / 100), for: UIControl.State.normal)
                self.btn3.setTitle(String(format: "%.1f", Double(JKSettingHelper.shared.channel3) / 100), for: UIControl.State.normal)
                self.btn4.setTitle(String(format: "%.1f", Double(JKSettingHelper.shared.channel4) / 100), for: UIControl.State.normal)
                self.btn5.setTitle(String(format: "%.1f", Double(JKSettingHelper.shared.channel5) / 100), for: UIControl.State.normal)
                self.btn6.setTitle(String(format: "%.1f", Double(JKSettingHelper.shared.channel6) / 100), for: UIControl.State.normal)
            }
        }
    }
}
