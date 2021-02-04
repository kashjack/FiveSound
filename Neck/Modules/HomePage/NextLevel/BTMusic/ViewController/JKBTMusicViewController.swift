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
    private var displayLink: CADisplayLink?
    private var isAnimation = false

    
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

    deinit {
        self.removeDisplayLink()
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

        self.displayLink  = CADisplayLink.init(target: self, selector: #selector(circle))
        self.displayLink!.add(to: RunLoop.main, forMode: RunLoop.Mode.default)
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
                self.isAnimation = !self.btnForPlay.isSelected
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
                self.isAnimation = JKSettingHelper.shared.playStatus
            }
            else if type == .device {
                self.jumpDeviceStatusVC()
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

    @objc private func circle() {
        if isAnimation {
            self.imgVForType.transform = self.imgVForType.transform.rotated(by: CGFloat.pi / 100)
        }
    }


    private func removeDisplayLink() {
        if self.displayLink == nil { return }
        self.displayLink!.remove(from: RunLoop.main, forMode: RunLoop.Mode.default)
        self.displayLink!.invalidate()
        self.displayLink = nil
    }


}
