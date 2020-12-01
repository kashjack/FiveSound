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
                self.index += 1
                JKBlueToothHelper.shared.writeCharacteristice(value: Data([85, 170, 1, 2, 3, self.index, (250-self.index)]))
//                self.navigationController?.pushViewController(JKMemoryViewController(), animated: true)
//                JKBlueToothHelper.shared.writeCharacteristice(value: <#T##Data#>)
                
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn2.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKFABAViewController(), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

        self.btn3.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKMemoryViewController(), animated: true)
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
                self.navigationController?.pushViewController(JKMemoryViewController(), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.btnForConnect.rx.tap.subscribe(onNext: {[weak self] element in
            guard let self = self else { return }
            let vc = JKDevicesViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }).disposed(by: self.disposeBag)

    }
    
 
}

