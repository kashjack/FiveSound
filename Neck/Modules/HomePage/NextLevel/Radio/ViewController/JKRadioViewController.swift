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
        
        self.btnForFaba.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKFABAViewController(), animated: true)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)


    }

}
