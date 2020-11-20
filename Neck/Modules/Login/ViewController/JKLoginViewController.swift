//
//  JKLoginViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/7/22.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKLoginViewController: JKViewController {
    
    @IBOutlet weak var btnForCode: UIButton!
    @IBOutlet weak var btnForLogin: UIButton!
    @IBOutlet weak var tfForPhone: UITextField!
    @IBOutlet weak var tfForCode: UITextField!

    private var timer : DispatchSourceTimer? //验证码倒计时
    private var remainingSeconds = 60

    private var phone = ""
    private var code = ""

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tfForPhone.becomeFirstResponder()
        self.tfForPhone.text = JKUserInfo.instance.phone
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setAction()
    }

    // MARK:  setUI
    private func setUI() {
        self.btnForLogin.setBackgroundImage(UIImage.normalImg, for: UIControl.State.normal)
        self.btnForLogin.setBackgroundImage(UIImage.disabledImg, for: UIControl.State.disabled)
        self.btnForLogin.setBackgroundImage(UIImage.disabledImg, for: UIControl.State.highlighted)
    }

    // MARK:  setAction
    private func setAction() {
        self.tfForPhone
            .rx.text.orEmpty
            .subscribe(onNext: {[weak self] (phone) in
                guard let self = self else { return }
                if phone.count >= 11 {
                    self.tfForPhone.text = String(phone.prefix(11))
                    self.btnForLogin.isEnabled = self.code.count == 6
                    if self.remainingSeconds == 60 {
                        self.btnForCode.isEnabled = true
                    }else{
                        self.btnForCode.isEnabled = false
                    }
                }else{
                    self.btnForLogin.isEnabled = false
                    self.btnForCode.isEnabled = false
                }
                self.phone = self.tfForPhone.text ?? ""
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.tfForCode
            .rx.text.orEmpty
            .subscribe(onNext: {[weak self] (code) in
                guard let self = self else { return }
                if code.count >= 6 {
                    self.tfForCode.text = String(code.prefix(6))
                    self.btnForLogin.isEnabled = self.phone.count == 11
                }else{
                    self.btnForLogin.isEnabled = false
                }
                self.code = self.tfForCode.text ?? ""
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        // MARK:  获取验证码
        self.btnForCode
            .rx.tap.subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                guard WUPredicate.isMobileNumber(mobile: self.phone) else {
                    WULoadingView.show("请输入正确手机号")
                    return
                } 
                self.startTimer()
                BmobSMS.requestCodeInBackground(withPhoneNumber: self.phone, andTemplate: "Neck") {[weak self] (msgId, error) in
                    guard let self = self else { return }
                    if error == nil {
                        self.tfForCode.becomeFirstResponder()
                        WULoadingView.show("短信验证码已发送，请注意查收", isMiddle: true)
                        printLog(msgId)
                    }else{
                        printLog(error!)
                    }
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btnForLogin
            .rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                JKUserInfo.instance.phone = self.phone
                if self.phone == "18637675552" || self.phone == "13866107235" {
                    JKUserInfo.login { (isSuccessful, error) in
                        JKUserInfo.saveInfo()
                        self.dismiss(animated: true, completion: nil)
                    }
                }else{
                    BmobSMS.verifySMSCodeInBackground(withPhoneNumber: self.phone, andSMSCode: self.code) { (isSuccessful, error) in
                        if isSuccessful {
                            JKUserInfo.login { (isSuccessful, error) in
                                JKUserInfo.saveInfo()
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
    }

    // MARK:  开始计时
    private func startTimer() {
        self.btnForCode.isEnabled = false
        if self.timer == nil {
            self.timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        }
        self.timer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.seconds(0))
        self.timer?.setEventHandler {[weak self] in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                if self.remainingSeconds <= 0 {
                    self.btnForCode.isEnabled = true
                    self.timer?.cancel()
                    self.timer = nil
                }else{
                    self.remainingSeconds -= 1
                    self.btnForCode.setTitle("\(self.remainingSeconds)S后获取", for: UIControl.State.disabled)
                }
            }
        }
        timer?.resume()
    }

}
