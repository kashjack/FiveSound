//
//  JKHomePageView.swift
//  Neck
//
//  Created by worldunionYellow on 2020/6/23.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKHomePageView: UIView {

    public lazy var btnForSearch: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.hexStringToColor("#F2F2F2")
        button.setTitle("颈椎病", for: UIControl.State.normal)
        button.setTitleColor(UIColor.hexStringToColor("#9C9C9C"), for: UIControl.State.normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setImage(UIImage.init(named: "icon_homePage_serch"), for: UIControl.State.normal)
        button.adjustsImageWhenHighlighted = false
        return button
    }()

    public lazy var btnForMessage: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage.init(named: "icon_homePage_message"), for: UIControl.State.normal)
        button.adjustsImageWhenHighlighted = false
        return button
    }()

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }

    private func setUI(){
        self.addSubview(self.btnForSearch)
        self.btnForSearch.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-3)
            make.right.equalToSuperview().offset(-50)
            make.height.equalTo(32)
        }

        self.addSubview(self.btnForMessage)
        self.btnForMessage.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.btnForSearch)
            make.right.equalToSuperview().offset(-15)
            make.width.height.equalTo(30)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
