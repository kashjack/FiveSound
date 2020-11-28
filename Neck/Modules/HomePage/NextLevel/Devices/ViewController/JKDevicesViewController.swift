//
//  JKDevicesViewController.swift
//  Neck
//
//  Created by 周美汝 on 2020/11/28.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKDevicesViewController: JKViewController {
    
    @IBOutlet weak var btnForBack: UIButton!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.registerNibCell(JKDeviceTableViewCell.nameOfClass)
        tableView.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setAction()
    }

    // MARK:  setUI
    private func setUI() {
        let visualEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: visualEffect)
        blurView.alpha = 1
        self.tableView.addSubview(blurView)
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.btnForBack.snp.bottom)
        }
    }
    
    // MARK:  setAction
    private func setAction() {
        self.btnForBack.rx.tap.subscribe(onNext: {[weak self] element in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
    }

}
