//
//  JKButton.swift
//  Neck
//
//  Created by worldunionYellow on 2020/12/21.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUI()
    }

    // 可视化IB初始化调用
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setUI()
        //        fatalError("init(coder:) has not been implemented")
    }


    private func setUI() {
        guard let title = self.titleLabel?.text else { return }
        let attTitle = NSMutableAttributedString.init(string: title)
        var range = NSRange()
        range.location = 0
        range.length = attTitle.length
        attTitle.setAttributes([NSAttributedString.Key.underlineStyle : NSNumber(value: NSUnderlineStyle.single.rawValue)], range: range)
        self.setAttributedTitle(attTitle, for: UIControl.State.normal)
    }
    
    public func setButtonColor(isSelected: Bool) {
        if isSelected {
            guard let title = self.titleLabel?.text else { return }
            let attTitle = NSMutableAttributedString.init(string: title)
            var range = NSRange()
            range.location = 0
            range.length = attTitle.length
            attTitle.setAttributes([NSAttributedString.Key.underlineStyle : NSNumber(value: NSUnderlineStyle.single.rawValue), NSAttributedString.Key.underlineColor : UIColor.white, NSAttributedString.Key.foregroundColor : UIColor.white], range: range)
            self.setAttributedTitle(attTitle, for: UIControl.State.normal)
        }else{
            self.setUI()
        }
    }


}
