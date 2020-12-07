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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUI()
        self.setAction()

    }
    
    // MARK:  setUI
    private func setUI() {
        for i in 0...10 {
            let viewBlock1 = UIView.init(backGroundColor: UIColor.white)
            self.view.addSubview(viewBlock1)
            viewBlock1.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.slider1).offset(-40)
                make.left.equalTo(self.slider1).offset((JKSizeHelper.width - 145) / 10 * CGFloat(i))
                make.width.equalTo(1)
                make.height.equalTo(8)
            }
            
            let viewBlock2 = UIView.init(backGroundColor: UIColor.white)
            self.view.addSubview(viewBlock2)
            viewBlock2.snp.makeConstraints { (make) in
                make.bottom.equalTo(self.slider2).offset(-40)
                make.left.equalTo(self.slider2).offset((JKSizeHelper.width - 145) / 10 * CGFloat(i))
                make.width.equalTo(1)
                make.height.equalTo(8)
            }
            
            if i == 0 || i == 5 || i == 10 {
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
            lab.text = "\(i * 10 - 10)"
            lab.textAlignment = .center
        }
        
        self.backView.addSubview(self.moveView)
        self.moveView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
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
        printLog(JKSettingHelper.shared.currentVoiceValue)
        JKSettingHelper.shared.currentVoiceValue = UInt8(self.slider.value)
        JKSettingHelper.setVoiceValue()
    }
    
    
    // MARK:  setAction
    private func setAction() {
        self.btnForBack.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.slider.addTarget(self, action: #selector(valueChange), for: UIControl.Event.valueChanged)

        self.slider1.rx.value.asObservable().subscribe(onNext:  { [weak self] value in
            guard let self = self else { return }
            self.moveView.snp.updateConstraints { (make) in
                make.centerY.equalToSuperview().offset(30 * CGFloat(value))
            }
        }).disposed(by: self.disposeBag)

        self.slider2.rx.value.asObservable().subscribe(onNext:  { [weak self] value in
            guard let self = self else { return }
            self.moveView.snp.updateConstraints { (make) in
                make.centerX.equalToSuperview().offset(15 * CGFloat(value))
            }
        }).disposed(by: self.disposeBag)
        
        self.btnForReset.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.slider1.value = 0
                self.slider2.value = 0
                self.moveView.center = CGPoint.init(x: 75, y: 150)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
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
        self.slider1.value = Float(y) / 30 - 5
        self.slider2.value = Float(x) / 15 - 5

    }

}

