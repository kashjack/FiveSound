//
//  JKVerticalButton.swift
//  Neck
//
//  Created by worldunionYellow on 2020/7/22.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

@IBDesignable
class JKVerticalButton: UIButton {

    public var disposeBag = DisposeBag()
    deinit {
        self.disposeBag = DisposeBag()
    }

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
        self.titleLabel?.textAlignment = NSTextAlignment.center
        self.imageView?.contentMode = UIView.ContentMode.center
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageW = contentRect.size.width
        let imageH = contentRect.size.height * 0.5
        return CGRect(x: 0, y: contentRect.size.height * 0.1, width: imageW, height: imageH)
    }

    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let titleY = contentRect.size.height * 0.65
        let titleW = contentRect.size.width
        let titleH = contentRect.size.height * 0.2
        return CGRect(x: 0, y: titleY, width: titleW, height: titleH)
    }

}

