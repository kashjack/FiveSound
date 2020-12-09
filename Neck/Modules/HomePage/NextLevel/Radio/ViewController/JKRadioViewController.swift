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
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnForMono: UIButton!
    @IBOutlet weak var btnForSub: UIButton!
    @IBOutlet weak var btnForLoud: UIButton!
    
    @IBOutlet weak var labForChannel: UILabel!
    private lazy var slideView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexStringToColor("#7A0AAD")
        return view
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JKSettingHelper.getRadioInfo()
    }
    
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
        
        self.backView.addSubview(self.slideView)
        self.slideView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(10)
            make.height.equalTo(40)
        }
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
            .subscribe(onNext: {
                JKSettingHelper.shared.currentChannel = 17
                JKSettingHelper.setChannel()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.btnForMono.rx.tap.subscribe(onNext: { element in
            JKSettingHelper.setMono()
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
        }
    }
}
