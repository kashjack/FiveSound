//
//  UISlider+Extension.swift
//  Neck
//
//  Created by kashjack on 2020/12/5.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKSlider: UISlider {

    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let newRect = CGRect(x: rect.origin.x - 10, y: rect.origin.y, width: rect.size.width + 20, height: rect.size.height)
        
        return  super.thumbRect(forBounds: bounds, trackRect: newRect, value: value).insetBy(dx: 10, dy: 10)
    }
    
}
