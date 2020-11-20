//
//  UIView+Extension.swift
//  Swift-Useful-Extensions
//
//  Created by Yin Xu on 6/9/14.
//  Copyright (c) 2014 YinXuApp. All rights reserved.
//
import CoreFoundation
import Foundation
import UIKit

@IBDesignable
extension UIView {
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
}

@IBDesignable
class WUView: UIView,Nibloadable {
    
//    var disposeBag = DisposeBag()

//    deinit {
//        self.disposeBag = DisposeBag()
//    }
    
//    override func prepareForInterfaceBuilder() {
//        super.prepareForInterfaceBuilder()
//        self.disposeBag = DisposeBag()
//    }
    
//    @IBInspectable var cornerRadius: CGFloat = 0.0 {
//        didSet {
//            layer.cornerRadius = cornerRadius
//            layer.masksToBounds = true
//        }
//    }
    
    @IBInspectable var borderColor: UIColor = UIColor() {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    func hp_textFiledEditChanged(_ sender:Notification){}
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}





public extension UIView {
    
    /// 分割线的View
    static var splitLineView: UIView {
        return UIView.init(backGroundColor: UIColor.darkGray)
    }
    
    /// 移除当前视图的所有子视图
    func removeAllSubviews() -> Void {
        _ = self.subviews.map { $0.removeFromSuperview()}
    }
    
    convenience init(backGroundColor: UIColor) {
        self.init(frame: .zero)
        self.backgroundColor = backGroundColor
    }
    
    /// 截取整个View
    ///
    /// - Parameter save: 是否保存到系统相册
    func screenShot(_ save: Bool) -> UIImage? {
        
        guard frame.size.height > 0 && frame.size.width > 0 else {
            return nil
        }
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        // 保存到相册
        if save {
            UIImageWriteToSavedPhotosAlbum(image!, self, nil, nil)
        }
        return image
    }

    // MARK:  切圆角
    // Parameters:
    //   corners: 需要实现为圆角的角，可传入多个
    //   radii: 圆角半径

    func corner(byRoundingCorners corners: UIRectCorner?, bounds: CGRect? = nil, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds ?? self.bounds, byRoundingCorners: corners ?? [UIRectCorner.topLeft, UIRectCorner.topRight, UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }

    func corner(byRoundingCorners corners: UIRectCorner?, radius: CGFloat, bordColor: UIColor, bordWidth: CGFloat, backColor: UIColor) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners ?? [UIRectCorner.topLeft, UIRectCorner.topRight, UIRectCorner.bottomLeft, UIRectCorner.bottomRight], cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.lineWidth = bordWidth
        maskLayer.lineCap = CAShapeLayerLineCap.square
        maskLayer.strokeColor = bordColor.cgColor
        maskLayer.fillColor = backColor.cgColor
        for lay in self.layer.sublayers ?? [] {
            if lay is CAShapeLayer {
                lay.removeFromSuperlayer()
            }
        }
        self.layer.addSublayer(maskLayer)
    }

}

extension UIView {
    
    //frame.origin.x
    public var wu_left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    //frame.origin.y
    public var wu_top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    //frame.origin.x + frame.size.width
    public var wu_right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.origin.x = wu_right - frame.size.width
            self.frame = frame
        }
    }
    
    //frame.origin.y + frame.size.height
    public var wu_bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.origin.y = wu_bottom - frame.origin.y
            self.frame = frame
        }
    }
    
    //frame.size.width
    public var wu_width: CGFloat {
        get {
            return self.frame.size.width
        }
        set {
            var frame = self.frame
            frame.size.width = wu_width
            self.frame = frame
        }
    }
    
    //frame.size.height
    public var wu_height: CGFloat {
        get {
            return self.frame.size.height
        }
        set {
            var frame = self.frame
            frame.size.height = wu_height
            self.frame = frame
        }
    }
    
    //center.x
    public var wu_centerX: CGFloat {
        get {
            return self.center.x
        }
        set {
            self.center = CGPoint.init(x: wu_centerX, y: self.center.y)
        }
    }
    
    //center.y
    public var wu_centerY: CGFloat {
        get {
            return self.center.y
        }
        set {
            self.center = CGPoint.init(x: self.center.x, y: wu_centerY)
        }
    }
    
    //frame.origin
    public var wu_origin: CGPoint {
        get {
            return self.frame.origin
        }
        set {
            var frame = self.frame
            frame.origin = wu_origin
            self.frame = frame
        }
    }
    
    //frame.size
    public var wu_size: CGSize {
        get {
            return self.frame.size
        }
        set {
            var frame = self.frame
            frame.size = wu_size
            self.frame = frame
        }
    }
    
    //maxX
    public var wu_maxX: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
    }
    
    //maxY
    public var wu_maxY: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
    
}


//UIView
extension UIView{
    var width:      CGFloat { return frame.size.width }
    var height:     CGFloat { return frame.size.height }
    var size:       CGSize  { return frame.size}
    
    var origin:     CGPoint { return frame.origin }
    var x:          CGFloat { return frame.origin.x }
    var y:          CGFloat { return frame.origin.y }
    var centerX:    CGFloat { return center.x }
    var centerY:    CGFloat { return center.y }
    var left:       CGFloat { return frame.origin.x }
    var right:      CGFloat { return frame.origin.x + frame.size.width }
    var top:        CGFloat { return frame.origin.y }
    var bottom:     CGFloat { return frame.origin.y + frame.size.height }
    
    func getScaleHeight(width1:CGFloat,height1:CGFloat,width2:CGFloat,height2:CGFloat) -> CGFloat {
        let height1 = (width2 * height1) / width1
        return height1
    }
    
    func setWidth(width:CGFloat)
    {
        frame.size.width = width
    }
    
    func setHeight(height:CGFloat)
    {
        frame.size.height = height
    }
    
    func setSize(size:CGSize)
    {
        frame.size = size
    }
    
    func setOrigin(point:CGPoint)
    {
        frame.origin = point
    }
    
    func setX(x:CGFloat) //only change the origin x
    {
        frame.origin = CGPoint(x: x, y: frame.origin.y)
    }
    
    func setY(y:CGFloat) //only change the origin x
    {
        frame.origin = CGPoint(x: frame.origin.x, y: y)
    }
    
    func setCenterX(x:CGFloat) //only change the origin x
    {
        center = CGPoint(x: x, y: center.y)
    }
    
    func setCenterY(y:CGFloat) //only change the origin x
    {
        center = CGPoint(x: center.x, y: y)
    }
    
    func roundCorner(radius:CGFloat)
    {
        layer.cornerRadius = radius
    }
    
    func setTop(top:CGFloat)
    {
        frame.origin.y = top
    }
    
    func setLeft(left:CGFloat)
    {
        frame.origin.x = left
    }
    
    func setRight(right:CGFloat)
    {
        frame.origin.x = right - frame.size.width
    }
    
    func setBottom(bottom:CGFloat)
    {
        frame.origin.y = bottom - frame.size.height
    }
    
    //MARK: --设置圆角
    func setLayerCornerRadius(radius: CGFloat?) -> Void {
        layer.cornerRadius = radius!
        layer.masksToBounds = true
        layer.shadowRadius = 0
        layer.shadowOpacity = 0
        layer.shadowOffset = CGSize(width:0,height:0)
    }
    
    //MARK: --设置边框
    func setLayerBorderAnColor(borderWidth:CGFloat,color:UIColor) -> Void {
        layer.borderWidth = borderWidth;
        layer.borderColor = color.cgColor;
    }
    
    //MARK: --设置view指定一个地方圆角
    func setViewByRoundingCorners(corners:UIRectCorner,cornerRadii:CGSize) {
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)//[UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:corners cornerRadii:cornerRadii];
        
        let maskLayer = CAShapeLayer();
        
        //    maskLayer.frame = self.bounds;
        maskLayer.path = maskPath.cgPath;
        
        layer.mask = maskLayer;
    }

    //MARK: 清楚UIPickerView分割线
    func clearPickerVSpearatorLine() {
        for (_,subView) in self.subviews.enumerated() {
            if subView is UIPickerView {
                for (_, pickerV) in subView.subviews.enumerated() {
                    if pickerV.height <= 1 {//取出分割线view
                        pickerV.isHidden = true//隐藏分割线
                    }
                }
            }
        }
    }
}


extension UIImageView{
    func roundImage()
    {
        //height and width should be the same
        clipsToBounds = true
        layer.cornerRadius = frame.size.width / 2;
    }
}

extension UIImage{
    func croppedImage(bound : CGRect) -> UIImage
    {
        let scaledBounds : CGRect = CGRect(x: bound.origin.x * scale, y: bound.origin.y * scale, width: bound.size.width * scale, height: bound.size.height * scale)
        let imageRef = cgImage?.cropping(to: scaledBounds)
        let croppedImage : UIImage = UIImage(cgImage: imageRef!, scale: scale, orientation: UIImage.Orientation.up)
        return croppedImage;
    }
}




