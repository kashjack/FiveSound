//
//  LoadingView.swift
//  WUKnowledge
//
//  Created by liujinliang on 2019/6/12.
//  Copyright © 2019 worldunionViolet. All rights reserved.
//

import Foundation

class WULoadingView : UIView {

    static let sharedView = WULoadingView()

    static func show(view: UIView = UIApplication.shared.keyWindow!, isUserInteractionEnabled: Bool = true) {
        WULoadingView.sharedView.isUserInteractionEnabled = !isUserInteractionEnabled
        let imageV = UIImageView.init()
        WULoadingView.sharedView.addSubview(imageV)
        imageV.animationDuration = 0.75 //图片播放一次所需时长
        imageV.animationRepeatCount = 0 //图片播放次数,0表示无限
        imageV.contentMode = .scaleAspectFit
        imageV.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.equalTo(20)
        }
        var images:[UIImage] = []
        for i in 1...20 {
            images.append(UIImage.init(named: "loading_\(i).png")!)
        }
        imageV.animationImages = images
        imageV.startAnimating()
        WULoadingView.sharedView.alpha = 0
        view.addSubview(WULoadingView.sharedView)
        WULoadingView.sharedView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.35) {
            WULoadingView.sharedView.alpha = 1
        }
        DispatchQueue.main.after(TimeInterval.init(30)) {
            WULoadingView.hide()
        }
    }

    static func hide() {
        UIView.animate(withDuration: TimeInterval.init(0.35), animations: {
            WULoadingView.sharedView.alpha = 0
        }) { (finish) in
            WULoadingView.sharedView.removeAllSubviews()
            WULoadingView.sharedView.removeFromSuperview()
        }
    }

    static func show(_ message: String?, _ time: CGFloat = 2, isMiddle: Bool = false) {
        guard let `message` = message else { return }
        let showView = UIView.init(frame: CGRect.init(x: 1, y: 1, width: 1, height: 1))
        showView.alpha = 1.0
        showView.layer.cornerRadius = 3.0
        showView.layer.masksToBounds = true
        showView.layer.zPosition = CGFloat.greatestFiniteMagnitude//最外层
        showView.backgroundColor = .black
        JKStackManager.keyWindow.addSubview(showView)
        let showLabel = UILabel.init()
        let attribute = [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]
        let labelSize = NSString.init(string: message).boundingRect(with: CGSize.init(width: JKSizeHelper.width - 40, height: 9000), options: .usesLineFragmentOrigin, attributes: attribute, context: nil).size
        showLabel.frame = CGRect.init(x: 10, y: 5, width: labelSize.width, height: labelSize.height)
        showLabel.textAlignment = .center
        showLabel.textColor = .white
        showLabel.text = message
        showLabel.numberOfLines = 0
        showLabel.backgroundColor = .clear
        showLabel.font = UIFont.systemFont(ofSize: 15)
        showView.addSubview(showLabel)
        if isMiddle {
            showView.frame = CGRect.init(x: (JKSizeHelper.width - labelSize.width - 20) / 2, y: (JKSizeHelper.height / 7 * 4), width: labelSize.width + 20, height: labelSize.height + 10)
        }else{
            showView.frame = CGRect.init(x: (JKSizeHelper.width - labelSize.width - 20) / 2, y: (JKSizeHelper.height / 5 * 4), width: labelSize.width + 20, height: labelSize.height + 10)
        }
        UIView.animate(withDuration: TimeInterval(time), animations: {
            showView.alpha = 0
        }) { (finished) in
            showView.removeFromSuperview()
        }
    }
}
