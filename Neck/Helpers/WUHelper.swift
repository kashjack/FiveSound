//
//  WUHelper.swift
//  WUKnowledge
//
//  Created by worldunionYellow on 2019/5/24.
//  Copyright © 2019 worldunionViolet. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func kfCache(_ imageStr: String, placeholderImage : UIImage?){
        guard let url = URL.init(string: imageStr) else {
            self.image = placeholderImage
            return
        }
        let resource = ImageResource(downloadURL: url, cacheKey: url.path)
        self.kf.setImage(with: resource, placeholder: placeholderImage, options: [.fromMemoryCacheOrRefresh, .transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
    }

    func kfRefresh(_ imageStr: String, placeholderImage : UIImage?) {
        self.kf.setImage(with: URL.init(string: imageStr), placeholder: placeholderImage, options: [.forceRefresh, .transition(ImageTransition.fade(1))], progressBlock: nil, completionHandler: nil)
    }
}
extension UIButton {
    func kfCache(_ imageStr: String, placeholderImage : UIImage?){
        self.kf.setImage(with: URL.init(string: imageStr), for: UIControl.State.normal, placeholder: placeholderImage, options: [.fromMemoryCacheOrRefresh, .transition(.fade(1))], progressBlock: nil, completionHandler: nil)
    }
    func kfRefresh(_ imageStr: String, placeholderImage : UIImage?) {
        self.kf.setImage(with: URL.init(string: imageStr), for: UIControl.State.normal, placeholder: placeholderImage, options: [.forceRefresh, .transition(.fade(1))], progressBlock: nil, completionHandler: nil)
    }
}


//MARK: webUrl处理，编码
func fullWebUrl(url:String) -> String {
    let range = url.range(of: "http")
    let ranges = url.range(of: "https")
    var encodingUrl = ""
    if range != nil || ranges != nil  {
        encodingUrl = url
    }else{
        encodingUrl = String(format: "%@/%@", kBaseUrl, url)
    }
    if url.containsString(s: "yun.allinpay.com") ||
        url.containsString(s: "{") ||
        url.containsString(s: "\"") ||
        url.containsString(s: "'") ||
        url.containsString(s: "signContract") ||
        url.containsString(s: "%"){//
        //通联电子签约忽略编码
        return encodingUrl
    }
    return encodingUrl.urlStringEncoding()
}

// 字典排序
 func sortedParams(_ params:[String:Any]?) -> [String:Any]? {
    guard let `params` = params else { return nil }
    // 排序
    let keys = params.keys
    let sorted_key = keys.sorted(by: {$1 > $0})
    var par: [String:Any] = [:]
    for key in sorted_key {
        par[key] = params[key]
    }
    return par
}
