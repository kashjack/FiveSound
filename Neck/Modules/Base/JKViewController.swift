//
//  JKViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/6/22.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKViewController: UIViewController {

    private lazy var leftBarButton: UIButton = {
        let button = UIButton.init(type: UIButton.ButtonType.custom)
        button.setImage(UIImage.init(named: "icon_back"), for: UIControl.State.normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: -20, bottom: 5, right: 5)
        return button
    }()

    public let disposeBag = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCommonUI()
        self.setAction()
    }

    // MARK:  移除通知
    deinit{
//        self.disposeBag = DisposeBag()
        NotificationCenter.default.removeObserver(self)
        printLog("\(self)已释放")
    }

    // MARK:  setUI
    private func setUI() {
        if self is JKHomePageViewController
            || self is JKFABAViewController
            || self is JKRadioViewController
            || self is JKMemoryViewController
            || self is JKTRBAViewController
        {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
        }
        else{
            self.navigationController?.setNavigationBarHidden(false, animated: false)
        }
        self.view.backgroundColor = UIColor.white
    }

    // MARK:  setCommonUI
    private func setCommonUI() {
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }
        if let count = navigationController?.viewControllers.count, count > 1 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: self.leftBarButton)
            self.navigationItem.leftBarButtonItem?.customView?.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        }
    }

    // MARK:  setAction
    private func setAction() {
        self.leftBarButton
            .rx.controlEvent(.touchUpInside)
            .subscribe(onNext: {[weak self] element in
                guard let self = self else { return }
                self.Pop()
                }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)

    }

    // MARK:  Push
    public func Push(vc: JKViewController, _ animated: Bool = true) {
        guard let nav = JKViewController.topViewController()?.navigationController else { return }
        nav.pushViewController(vc, animated: animated)
    }

    // MARK:  Present
    public func Present(vc: JKViewController, _ animated: Bool = true) {
        self.present(vc, animated: animated, completion: nil)
    }

    // MARK:  Back
    public func Pop(_ animated: Bool = true) {
        guard let nav = JKViewController.topViewController()?.navigationController else { return }
        nav.popViewController(animated: animated)
    }

    // MARK:  弹框
    func alertDiaLog(title: String, message: String, preferredStyle: UIAlertController.Style, actionTitles: [String], actions: [((UIAlertAction) -> Void)?]) {
        guard actionTitles.count == actions.count else { return }
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: preferredStyle)
        for i in 0..<actionTitles.count {
            let title = actionTitles[i]
            let action = actions[i]
            if title == "取消" {
                let alertAction = UIAlertAction.init(title: title, style: UIAlertAction.Style.cancel, handler: action)
                alertController.addAction(alertAction)
            }else{
                let alertAction = UIAlertAction.init(title: title, style: UIAlertAction.Style.default, handler: action)
                alertController.addAction(alertAction)
            }
        }
        self.present(alertController, animated: true, completion: nil)
    }

}
extension JKViewController {

    @objc class func topViewController() -> UIViewController? {
        return self.topViewControllerWithRootViewController(viewController: self.getCurrentWindow().rootViewController)
    }

    @objc class func getCurrentWindow() -> UIWindow {
        return kAppDelegate.window!
    }

    @objc class func topViewControllerWithRootViewController(viewController :UIViewController?) -> UIViewController? {
        if viewController == nil {
            return nil
        }
        if viewController?.presentedViewController != nil {
            return self.topViewControllerWithRootViewController(viewController: viewController?.presentedViewController!)
        }else if viewController?.isKind(of: UITabBarController.self) == true {
            return self.topViewControllerWithRootViewController(viewController: (viewController as! UITabBarController).selectedViewController)
        }else if viewController?.isKind(of: UINavigationController.self) == true || viewController?.isKind(of: JKNavigationController.self) == true {
            return self.topViewControllerWithRootViewController(viewController: (viewController as! UINavigationController).visibleViewController)
        }else {
            return viewController
        }
    }
}
