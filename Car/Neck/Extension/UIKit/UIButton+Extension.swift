//
//  UIButton+Extension.swift
//  HomePlus
//
//  Created by xp on 2018/4/25.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit


//MARK: -定义button相对label的位置
enum YWButtonEdgeInsetsStyle {
    case Top
    case Left
    case Right
    case Bottom
}

extension UIButton {
    
    func layoutButton(style: YWButtonEdgeInsetsStyle, imageTitleSpace: CGFloat) {
        //得到imageView和titleLabel的宽高
        let imageWidth = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        
        var labelWidth: CGFloat! = 0.0
        var labelHeight: CGFloat! = 0.0
        
        labelWidth = self.titleLabel?.intrinsicContentSize.width
        labelHeight = self.titleLabel?.intrinsicContentSize.height
        
        //初始化imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero
        
        //根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .Top:
            //上 左 下 右
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight-imageTitleSpace/2, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!, bottom: -imageHeight!-imageTitleSpace/2, right: 0)
            break;
            
        case .Left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -imageTitleSpace/2, bottom: 0, right: imageTitleSpace)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: imageTitleSpace/2, bottom: 0, right: -imageTitleSpace/2)
            break;
            
        case .Bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight!-imageTitleSpace/2, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight!-imageTitleSpace/2, left: -imageWidth!, bottom: 0, right: 0)
            break;
            
        case .Right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+imageTitleSpace/2, bottom: 0, right: -labelWidth-imageTitleSpace/2)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth!-imageTitleSpace/2, bottom: 0, right: imageWidth!+imageTitleSpace/2)
            break;
            
        }
        
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
        
    }
}

extension UIButton {

    // MARK: --- 表单提交按钮
    convenience init(formBtnTitle: String) {
        self.init(type: .custom)
        setTitle(formBtnTitle, for: .normal)
        
        setBackgroundImage(UIImage.imageWithColor(color: UIColor.red), for: .normal)
        setBackgroundImage(UIImage.imageWithColor(color: UIColor.gray), for: .disabled)
        setBackgroundImage(UIImage.imageWithColor(color: UIColor.blue), for: .highlighted)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        titleLabel?.textAlignment = .center
        isEnabled = false
    }
    
    // MARK: --- 分段选择器按钮的创建
    convenience init(title: String, bNormalImg: UIImage?, bSelectedImg: UIImage?){
        self.init(type: .custom)
        self.setBackgroundImage(bNormalImg, for: .normal)
        self.setBackgroundImage(bSelectedImg, for: .selected)
        self.setTitleColor(.white, for: .selected)
//        self.setTitleColor(UIColor.titleTextColor, for: .normal)
        self.adjustsImageWhenHighlighted = false
        self.setTitle(title, for: .normal)
    }
    
    // 只有默认北
    convenience init(normalbackgroundImage: String) {
        self.init()
        self.setBackgroundImage(UIImage(named: normalbackgroundImage), for: .normal)
    }
    
    // 创建一般按钮
    convenience init(title: String, titleColor: UIColor, backGroundColor: UIColor, font: UIFont = .systemFont(ofSize: 13)) {
        self.init()
        self.backgroundColor = backGroundColor
        
        self.setTitle(title, for: UIControl.State())
        
        self.titleLabel?.font = font
        
        self.setTitleColor(titleColor, for: UIControl.State())
        
        self.layer.cornerRadius = 5
        
        self.layer.masksToBounds = true
    }
    
    convenience init(title: String, titleColor: UIColor, font: UIFont = .systemFont(ofSize: 13)) {
        self.init()
        
        self.setTitle(title, for: UIControl.State())
        
        self.titleLabel?.font = font
        
        self.setTitleColor(titleColor, for: UIControl.State())
    }
    
    convenience init(title: String, titleColor: UIColor, normalImg: UIImage?, selectedimg: UIImage?) {
        self.init()
        
        self.setTitle(title, for: .normal)
        
        self.setTitleColor(titleColor, for: .normal)
        
        self.setImage(normalImg, for: .normal)
        
        self.setImage(selectedimg, for: .selected)
        
    }
    
    /// This method sets an image and title for a UIButton and
    ///   repositions the titlePosition with respect to the button image.
    ///
    /// - Parameters:
    ///   - image: Button image
    ///   - title: Button title
    ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
    ///   - additionalSpacing: Spacing between image and title
    ///   - state: State to apply this behaviour
    @objc func set(image: UIImage?, title: String, titlePosition: UIView.ContentMode, additionalSpacing: CGFloat, state: UIControl.State){
        imageView?.contentMode = .center
        setImage(image, for: state)
        
        positionLabelRespectToImage(title: title, position: titlePosition, spacing: additionalSpacing)
        
        titleLabel?.contentMode = .center
        setTitle(title, for: state)
    }
    
    @objc func setNormal(_ title:String) {
        setTitle(title, for: UIControl.State.normal)
    }
    
    /// This method sets an image and an attributed title for a UIButton and
    ///   repositions the titlePosition with respect to the button image.
    ///
    /// - Parameters:
    ///   - image: Button image
    ///   - title: Button attributed title
    ///   - titlePosition: UIViewContentModeTop, UIViewContentModeBottom, UIViewContentModeLeft or UIViewContentModeRight
    ///   - additionalSpacing: Spacing between image and title
    ///   - state: State to apply this behaviour
    @objc func set(image: UIImage?, attributedTitle title: NSAttributedString, at position: UIView.ContentMode, width spacing: CGFloat, state: UIControl.State){
        imageView?.contentMode = .center
        setImage(image, for: state)
        
        adjust(title: title, at: position, with: spacing)
        
        titleLabel?.contentMode = .center
        setAttributedTitle(title, for: state)
    }
    
    
    // MARK: Private Methods
    
    private func adjust(title: NSAttributedString, at position: UIView.ContentMode, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        let titleSize = title.size()
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func adjust(title: NSString, at position: UIView.ContentMode, with spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        
        // Use predefined font, otherwise use the default
        let titleFont: UIFont = titleLabel?.font ?? UIFont()
        let titleSize: CGSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func positionLabelRespectToImage(title: String, position: UIView.ContentMode, spacing: CGFloat) {
        let imageRect: CGRect = self.imageRect(forContentRect: frame)
        
        // Use predefined font, otherwise use the default
        let titleFont: UIFont = titleLabel?.font ?? UIFont()
        let titleSize: CGSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont])
        
        arrange(titleSize: titleSize, imageRect: imageRect, atPosition: position, withSpacing: spacing)
    }
    
    private func arrange(titleSize: CGSize, imageRect:CGRect, atPosition position: UIView.ContentMode, withSpacing spacing: CGFloat) {
        var titleInsets: UIEdgeInsets
        var imageInsets: UIEdgeInsets
        
        switch (position) {
        case .top:
            titleInsets = UIEdgeInsets(top: -(imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .bottom:
            titleInsets = UIEdgeInsets(top: (imageRect.height + titleSize.height + spacing), left: -(imageRect.width), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
        case .left:
            titleInsets = UIEdgeInsets(top: 0, left: -(imageRect.width * 2), bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -(titleSize.width * 2 + spacing))
        case .right:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        default:
            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
        titleEdgeInsets = titleInsets
        imageEdgeInsets = imageInsets
    }
    
//    private func positionLabelRespectToImage(title: String, position: UIView.ContentMode,
//                                             spacing: CGFloat) {
//        let imageSize = self.imageRect(forContentRect: self.frame)
//        let titleFont = self.titleLabel?.font!
//        let titleSize = title.size(withAttributes: [NSAttributedString.Key.font: titleFont!])
//        
//        var titleInsets: UIEdgeInsets
//        var imageInsets: UIEdgeInsets
//        
//        switch (position){
//        case .top:
//            titleInsets = UIEdgeInsets(top: -(imageSize.height + titleSize.height + spacing),
//                                       left: -(imageSize.width), bottom: 0, right: 0)
//            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
//        case .bottom:
//            titleInsets = UIEdgeInsets(top: (imageSize.height + titleSize.height + spacing),
//                                       left: -(imageSize.width), bottom: 0, right: 0)
//            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -titleSize.width)
//        case .left:
//            titleInsets = UIEdgeInsets(top: 0, left: -(imageSize.width * 2), bottom: 0, right: 0)
//            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0,
//                                       right: -(titleSize.width * 2 + spacing))
//        case .right:
//            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
//            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        default:
//            titleInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//            imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        }
//        
//        self.titleEdgeInsets = titleInsets
//        self.imageEdgeInsets = imageInsets
//    }
}


