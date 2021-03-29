//
//  Url&SizeHelper.swift
//  YCZC
//
//  Created by kashjack on 2018/1/4.
//  Copyright © 2018年 kashjack. All rights reserved.
//

import Foundation
import UIKit

//MARK: 冒号后 添加注释说明
//TODO: 一般用于写到哪了 做个标记，让后回来继续
//FIXME: 表示此处有bug 或者要优化 列如下


struct JKSizeHelper {

    static let top = UIApplication.shared.statusBarFrame.height
    static let bottom: CGFloat = isIPhoneX ? 34 : 0
    static let isIPhoneX = UIApplication.shared.statusBarFrame.height == 44
    static let navTop: CGFloat = 44
    static let barBottom: CGFloat = 49
    
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let videoTopOffset: CGFloat = isIPhoneX ? top : 0

}

func PIX(_ length : CGFloat) -> CGFloat {
    return JKSizeHelper.width / 375.0 * length
}


// MARK:  计算高度
func BoundingHeight(width: CGFloat, content: String) -> CGFloat{
    let size = content.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: [.usesLineFragmentOrigin], attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], context: nil).size
    return size.height < 20 ? 20 : size.height
}



// MARK:  根据Width改变图片大小
func changeImageSizeWithWidth(originalImage : UIImage, width : CGFloat) -> UIImage {
    if originalImage.size.width > width {
        let height = ceil(width * originalImage.size.height / originalImage.size.width)
        let size = CGSize.init(width: width, height: height)
        UIGraphicsBeginImageContext(size)
        originalImage.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage!
    }
    return originalImage
}

// MARK: 翻转图片
func fixOrientation(_ image : UIImage) -> UIImage{
    if image.imageOrientation == UIImage.Orientation.up {
        return image
    }else{
        var transform = CGAffineTransform.identity
        switch image.imageOrientation{
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
            break

        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by: CGFloat.pi / -2)
            break
            
        case .down, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: CGFloat.pi)
            break
            
        default:
            break
        }
        switch image.imageOrientation {
        case .rightMirrored, .leftMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        default:
            break
        }
        let ctx = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue)
        ctx?.concatenate(transform)
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx?.draw(image.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(image.size.height), height: CGFloat(image.size.width)))
            break
            
        default:
            ctx?.draw(image.cgImage!, in: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(image.size.width), height: CGFloat(image.size.height)))
            break
        }
        
        let cgimg: CGImage = (ctx?.makeImage())!
        let img = UIImage(cgImage: cgimg)
        
        return img
        
        
    }
    
}


// MARK: 时分秒格式化 totalTime 毫秒
func getMMSSFromSS(totalTime: Int64) -> String{
    var seconds = totalTime / 1000
    if seconds <= 0  {
        seconds = 0
    }
    let s = seconds % 60
    let m = (seconds - s) / 60 % 60
    let h = ((seconds - s) / 60 - m) / 60 % 24
    var time = String(format: "%.2d:%.2d", m, s)
    if h > 0 {
        time = String(format: "%.2d:%.2d:%.2d", h, m, s)
    }
    return time
}

// MARK:  数字化
func getTimeFromMMSS(timeStr: String) -> Int {
    let arr = timeStr.split(separator: ":").compactMap { (item) -> Int  in
        return Int("\(item)") ?? 0
    }
    switch arr.count {
    case 1:
        return arr[0]
    case 2:
        return arr[0] * 60 + arr[1]
    case 3:
        return arr[0] * 60 * 60 + arr[1] * 60 + arr[2]
    default:
        return 0
    }
    
}

