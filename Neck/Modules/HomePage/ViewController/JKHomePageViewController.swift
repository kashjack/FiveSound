//
//  JKHomePageViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/6/22.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKHomePageViewController: JKViewController {
    
    @IBOutlet weak var btn1: JKHomePageButton!
    @IBOutlet weak var btn2: JKHomePageButton!
    @IBOutlet weak var btn3: JKHomePageButton!
    @IBOutlet weak var btn4: JKHomePageButton!
    @IBOutlet weak var btn5: JKHomePageButton!
    
    @IBOutlet weak var btnForConnect: UIButton!
    
    private var index: UInt8 = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setAction()
        
    }

    // MARK:  setUI
    private func setUI() {
       

    }


    // MARK:  setAction
    private func setAction() {
        self.btn1.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKMemoryViewController(type: .aux), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn2.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKMemoryViewController(type: .bt), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn3.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKMemoryViewController(type: .usb), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn4.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKRadioViewController(), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn5.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKMemoryViewController(type: .sd), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.btnForConnect.rx.tap.subscribe(onNext: {[weak self] element in
            guard let self = self else { return }
            let vc = JKDevicesViewController()
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)

    }
    
}

