//
//  JKMemoryViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/11/23.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

enum MemoryType {
    case sd
    case usb
    case aux
    case none
}

class JKMemoryViewController: JKViewController {

    @IBOutlet weak var btnForBack: UIButton!
    @IBOutlet weak var imgVForTitle: UIImageView!
    @IBOutlet weak var imgVForType: UIImageView!
    @IBOutlet weak var btnForFaba: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btnForSub: UIButton!
    @IBOutlet weak var btnForLoud: UIButton!
    
    var type: MemoryType = .none
    
    convenience init(type: MemoryType) {
        self.init()
        self.type = type
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setAction()
    }
    
    // MARK:  setUI
    private func setUI() {
        if self.type == .aux {
            self.imgVForTitle.image = UIImage.init(named: "zt_1")
            self.imgVForType.image = UIImage.init(named: "icon_1")
        }
        else if self.type == .usb {
            self.imgVForTitle.image = UIImage.init(named: "zt_8")
            self.imgVForType.image = UIImage.init(named: "7_icon")

        }
        else if self.type == .sd {
            self.imgVForTitle.image = UIImage.init(named: "zt_3")
            self.imgVForType.image = UIImage.init(named: "2_icon_1")

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
        
        self.btn1.rx.tap.subscribe(onNext: {[weak self] element in
            guard let self = self else { return }
            self.btn1.isSelected = !self.btn1.isSelected
        }).disposed(by: self.disposeBag)

    }


}
