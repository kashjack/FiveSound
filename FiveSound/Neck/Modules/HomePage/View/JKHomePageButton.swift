//
//  JKHomePageButton.swift
//  Neck
//
//  Created by kashjack on 2020/11/22.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKHomePageButton: UIButton {
    
    @IBInspectable var bottomImage: UIImage = UIImage(){
        didSet {
            imgV.image = bottomImage
        }
    }

    var imgV: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUI()
    }

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageW = contentRect.size.height - 30
        let imageH = contentRect.size.height - 30
        return CGRect(x: 0, y: 0, width: imageW, height: imageH)
    }

    private func setUI() {
        self.imageView?.contentMode = .center
        self.addSubview(self.imgV)
        self.imgV.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    
    
}
