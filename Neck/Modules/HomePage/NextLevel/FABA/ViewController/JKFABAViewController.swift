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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fd_interactivePopDisabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setAction()

    }
    
    // MARK:  setAction
    private func setAction() {
        self.btnForBack.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.popViewController(animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.slider.rx.value.asObservable()
            .subscribe(onNext: {
                JKSettingHelper.setVoiceValue(value: UInt8($0))
            }).disposed(by: self.disposeBag)
        

    }

}
