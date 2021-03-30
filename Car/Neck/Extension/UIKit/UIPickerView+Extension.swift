//
//  UIPickerView+Extension.swift
//  HomePlus
//
//  Created by worldunionViolet on 2018/8/14.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import Foundation
import UIKit

extension UIDatePicker {
    func clearSpearatorLine() {
        for subV in self.subviews {
            if subV is UIPickerView {
                for subV2 in subV.subviews {
                    if subV2.wu_height < 1 {
                        subV2.alpha = 0//隐藏分割线
                    }
                }
            }
        }
    }
}


extension UIPickerView {
    func clearSpearatorLine() {
        for subV in self.subviews {
            for _subV in subV.subviews {
                if _subV.wu_height < 1 {
                    _subV.backgroundColor = .clear
                }
            }
        }
    }
}
