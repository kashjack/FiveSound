//
//  JKMineViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/7/22.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKMineViewController: JKViewController {

    @IBOutlet weak var viewForShadow: UIView!
    @IBOutlet weak var btnForPublish: UIButton!
    @IBOutlet weak var btnForCollect: UIButton!
    @IBOutlet weak var btnForBrowseh: UIButton!
    @IBOutlet weak var btnForAttention: UIButton!
    @IBOutlet weak var labForPublish: UILabel!
    @IBOutlet weak var labForCollect: UILabel!
    @IBOutlet weak var labForBrowseh: UILabel!
    @IBOutlet weak var labForAttention: UILabel!
    @IBOutlet weak var btnForSetting: UIButton!
    @IBOutlet weak var btnForMessage: UIButton!
    @IBOutlet weak var imgVForHead: UIImageView!
    @IBOutlet weak var labForNickName: UILabel!
    @IBOutlet weak var viewForToday: UIView!
    @IBOutlet weak var viewForAll: UIView!
    @IBOutlet weak var viewForThisWeek: UIView!
    @IBOutlet weak var viewForContinuous: UIView!


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.labForNickName.text = JKUserInfo.instance.nickname
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setAction()
    }

    // MARK:  setUI
    private func setUI() {
        self.setLayerShadow(view: self.viewForShadow)
        self.setLayerShadow(view: self.viewForToday)
        self.setLayerShadow(view: self.viewForAll)
        self.setLayerShadow(view: self.viewForThisWeek)
        self.setLayerShadow(view: self.viewForContinuous)
    }

    // MARK:  setAction
    private func setAction() {
        self.btnForSetting
            .rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.navigationController?.pushViewController(JKSettingViewController(), animated: true)
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
    }


    private func setLayerShadow(view: UIView) {
        view.layer.shadowColor = UIColor.hexStringToColor("#B6C3C3").cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 11
        view.layer.shadowOpacity = 1
        view.layer.masksToBounds = false
    }

}
