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
        self.updateUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        self.setAction()
        self.updateUI()
        self.setReceiveData()
    }
    
    // MARK:  setUI
    private func setUI() {
        self.btnForConnect.isSelected = (JKBlueToothHelper.shared.connectPeripheral != nil)

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
                viewBlock1.backgroundColor = UIColor.mainColor
                viewBlock2.backgroundColor = UIColor.mainColor
            }
        }
        
        for i in 0...2 {
            let lab1 = UILabel()
            lab1.textColor = UIColor.white
            lab1.font = UIFont.systemFont(ofSize: 10)
            self.view.addSubview(lab1)
            lab1.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.slider1).offset(-50)
                make.left.equalTo(self.slider1).offset((JKSizeHelper.width - 145) / 2 * CGFloat(i) - 7.5)
                make.width.equalTo(15)
                make.height.equalTo(8)
            }
            lab1.text = "\(i * 7 - 7)"
            lab1.textAlignment = .center

            let lab2 = UILabel()
            lab2.textColor = UIColor.white
            lab2.font = UIFont.systemFont(ofSize: 10)
            self.view.addSubview(lab2)
            lab2.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.slider2).offset(-50)
                make.left.equalTo(self.slider2).offset((JKSizeHelper.width - 145) / 2 * CGFloat(i) - 7.5)
                make.width.equalTo(15)
                make.height.equalTo(8)
            }
            lab2.text = "\(i * 7 - 7)"
            lab2.textAlignment = .center
        }
        
        self.backView.addSubview(self.moveView)
        self.moveView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        

        self.moveView.addGestureRecognizer(self.pan)
        self.pan.addTarget(self, action: #selector(dragView(pan:)))

        self.slider.addTarget(self, action: #selector(valueChange), for: UIControl.Event.valueChanged)
        self.slider1.addTarget(self, action: #selector(slide1Action), for: UIControl.Event.valueChanged)
        self.slider2.addTarget(self, action: #selector(slide2Action), for: UIControl.Event.valueChanged)
    }

    // MARK:  updateUI
    private func updateUI() {
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

        
        self.btnForReset.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.slider1.value = 0
                self.slider2.value = 0
                self.moveView.snp.updateConstraints { (make) in
                    make.center.equalToSuperview()
                }
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
            make.centerX.equalToSuperview().offset(150 / 14 * CGFloat(self.slider2.value))
        }
        self.setFafb()
    }
    
    private func setReceiveData(){
        JKBlueToothHelper.shared.receiveUpdate = { [weak self] type in
            guard let self = self else { return }
            if type == .voice {
                self.slider.value = Float(JKSettingHelper.shared.currentVoiceValue)
            }
            else if type == .fabaTrba {
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
        pan.view?.center = CGPoint.init(x: 20 + x, y: 20 + y)
        self.slider1.value = Float(y) / 300 * 14 - 7
        self.slider2.value = Float(x) / 150 * 14 - 7
        self.setFafb()
    }

}

