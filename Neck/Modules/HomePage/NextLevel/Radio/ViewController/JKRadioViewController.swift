//
//  JKRadioViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/11/23.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKRadioViewController: JKViewController {

    @IBOutlet weak var btnForBack: UIButton!
    
    @IBOutlet weak var btn8750: UIButton!
    @IBOutlet weak var btn9070: UIButton!
    @IBOutlet weak var btn9210: UIButton!
    @IBOutlet weak var btn9890: UIButton!
    @IBOutlet weak var btn10250: UIButton!
    @IBOutlet weak var btn10790: UIButton!
    @IBOutlet weak var btnForFaba: UIButton!
    @IBOutlet weak var btnForUp: UIButton!
    @IBOutlet weak var btnForDown: UIButton!
    @IBOutlet weak var slider: UISlider!
    
    private var timer: DispatchSourceTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        self.setAction()
        self.setReceiveData()
    }
    
    // MARK:  setUI
    private func setUI() {
        self.slider.maximumValue = Float(JKSettingHelper.shared.maxVoiceValue)
        self.slider.minimumValue = Float(JKSettingHelper.shared.minVoiceValue)
        self.slider.value = Float(JKSettingHelper.shared.currentVoiceValue)
        self.slider.addTarget(self, action: #selector(valueChange), for: UIControl.Event.valueChanged)

    }
    
    // MARK:  setAction
    private func setAction() {
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

        self.btn8750.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                JKBlueToothHelper.shared.writeCharacteristice(value: [85, 170, 0, 1, 3, 252])
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        
        self.btnForUp.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.startCycle(isUp: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btnForDown.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.startCycle(isUp: false)
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
            self.slider.value = Float(JKSettingHelper.shared.currentVoiceValue)
        }
    }

    // MARK:  开始循环
    private func startCycle(isUp: Bool) {
        self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global(qos: .default))
        self.timer!.schedule(wallDeadline: DispatchWallTime.now(), repeating: DispatchTimeInterval.milliseconds(100))
        self.timer!.setEventHandler {
            
        }
        self.timer!.resume()
    }

    
    
}
