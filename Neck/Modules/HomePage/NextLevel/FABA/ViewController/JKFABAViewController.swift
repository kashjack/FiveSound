//
//  JKFABAViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/11/23.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit


class JKFABAViewController: JKViewController {

    @IBOutlet weak var btnForBack: UIButton!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var slider1: UISlider!
    @IBOutlet weak var slider2: UISlider!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var btnForReset: UIButton!
    @IBOutlet weak var btnForConnect: UIButton!

    
    
    private var faba = FABA()
    
    private lazy var moveView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.hexStringToColor("8E2BBB")
        view.layer.cornerRadius = 20
        return view
    }()
    
    private let pan = UIPanGestureRecognizer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fd_interactivePopDisabled = true
        JKSettingHelper.getFaBaInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        self.setAction()
        self.setReceiveData()

    }
    
    // MARK:  setUI
    private func setUI() {
        for i in 0...14 {
            let viewBlock1 = UIView.init(backGroundColor: UIColor.white)
            self.view.addSubview(viewBlock1)
            viewBlock1.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.slider1).offset(-40)
                make.left.equalTo(self.slider1).offset((JKSizeHelper.width - 145) / 14 * CGFloat(i))
                make.width.equalTo(1)
                make.height.equalTo(8)
            }
            
            let viewBlock2 = UIView.init(backGroundColor: UIColor.white)
            self.view.addSubview(viewBlock2)
            viewBlock2.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.slider2).offset(-40)
                make.left.equalTo(self.slider2).offset((JKSizeHelper.width - 145) / 14 * CGFloat(i))
                make.width.equalTo(1)
                make.height.equalTo(8)
            }
            
            if i == 0 || i == 7 || i == 14 {
                viewBlock1.backgroundColor = UIColor.hexStringToColor("#7A0AAD")
                viewBlock2.backgroundColor = UIColor.hexStringToColor("#7A0AAD")
            }
        }
        
        for i in 0...2 {
            let lab = UILabel()
            lab.textColor = UIColor.white
            lab.font = UIFont.systemFont(ofSize: 8)
            self.view.addSubview(lab)
            lab.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.slider1).offset(-50)
                make.left.equalTo(self.slider1).offset((JKSizeHelper.width - 145) / 2 * CGFloat(i) - 7.5)
                make.width.equalTo(15)
                make.height.equalTo(8)
            }
            lab.text = "\(i * 7 - 7)"
            lab.textAlignment = .center
        }
        
        self.backView.addSubview(self.moveView)
        self.moveView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        self.slider.addTarget(self, action: #selector(valueChange), for: UIControl.Event.valueChanged)

        self.moveView.addGestureRecognizer(self.pan)
        self.pan.addTarget(self, action: #selector(dragView(pan:)))

        self.slider.maximumValue = Float(JKSettingHelper.shared.maxVoiceValue)
        self.slider.minimumValue = Float(JKSettingHelper.shared.minVoiceValue)
        self.slider.value = Float(JKSettingHelper.shared.currentVoiceValue)
    }
    
    @objc func valueChange() {
        if JKSettingHelper.shared.currentVoiceValue == UInt8(self.slider.value) {
            return
        }
        JKSettingHelper.shared.currentVoiceValue = UInt8(self.slider.value)
        JKSettingHelper.setVoiceValue()
    }
    
    
    // MARK:  setAction
    private func setAction() {
        // MARK:  蓝牙连接状态变化
        NotificationCenter.default.rx.notification(Notification.Name.init(NotificationNameBlueToothStateChange)).subscribe(onNext: {[weak self](notification) in
            guard let self = self else { return }
            self.btnForConnect.isSelected = (JKBlueToothHelper.shared.connectPeripheral != nil)
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        self.btnForBack.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.slider1.addTarget(self, action: #selector(slide1Action), for: UIControl.Event.valueChanged)
        self.slider2.addTarget(self, action: #selector(slide2Action), for: UIControl.Event.valueChanged)
        
        self.btnForReset.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.slider1.value = 0
                self.slider2.value = 0
                self.moveView.center = CGPoint.init(x: 75, y: 150)
                self.setFafb()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
    }
    
    @objc private func slide1Action() {
        self.moveView.snp.updateConstraints { (make) in
            make.centerY.equalToSuperview().offset(300 / 14 * CGFloat(self.slider1.value))
        }
        self.setFafb()
    }
    
    @objc private func slide2Action() {
        self.moveView.snp.updateConstraints { (make) in
            make.centerX.equalToSuperview().offset(150 / 14 * CGFloat(self.slider1.value))
        }
        self.setFafb()
    }
    
    private func setReceiveData(){
        JKBlueToothHelper.shared.receiveUpdate = { [weak self] type in
            guard let self = self else { return }
            if type == .voice {
                self.slider.value = Float(JKSettingHelper.shared.currentVoiceValue)
            }
            else if type == .faba {
                self.slider1.value = Float(JKSettingHelper.shared.faba.fa) - 7
                self.slider2.value = Float(JKSettingHelper.shared.faba.fb) - 7
            }
        }
    }
    
    // MARK:  setFafb
    private func setFafb() {
        if self.faba.fa != UInt8(self.slider1.value + 7) {
            self.faba.fa =  UInt8(self.slider1.value + 7)
            JKSettingHelper.setFabaA(value: self.faba.fa)
        }
        
        if self.faba.fb != UInt8(self.slider2.value + 7) {
            self.faba.fb =  UInt8(self.slider2.value + 7)
            JKSettingHelper.setFabaB(value: self.faba.fb)
        }
    }
    
    // MARK:  拖动view事件
    @objc private func dragView(pan: UIPanGestureRecognizer) {
        let point = pan.location(in: self.backView)
        var x = point.x
        var y = point.y
        if x < 0 { x = 0}
        if x > 150 { x = 150}
        if y < 0 { y = 0 }
        if y > 300 { y = 300 }
        pan.view?.center = CGPoint.init(x: x, y: y)
        self.slider1.value = Float(y) / 300 * 14 - 7
        self.slider2.value = Float(x) / 150 * 14 - 7
        self.setFafb()
    }

}

