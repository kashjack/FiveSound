//
//  WUStackManager.swift
//  WUKnowledge
//
//  Created by worldunionYellow on 2019/11/22.
//  Copyright © 2019 worldunionViolet. All rights reserved.
//

import UIKit

class JKStackManager: NSObject {

    static let shared = JKStackManager()

    static var keyWindow: UIWindow {
        return UIApplication.shared.delegate!.window!!
    }

    // MARK: 初始化栈管理器
    func setupTabbarController() {
        let tabBarController = JKTabBarController()
        tabBarController.delegate = self
        JKStackManager.keyWindow.rootViewController = tabBarController
    }


    static func logout() {
        JKStackManager.showHomePage()
        let vc = JKNavigationController.init(rootViewController: JKLoginViewController())
        JKViewController.topViewController()?.present(vc, animated: true, completion: nil)
//        UIView.transition(with: JKStackManager.keyWindow, duration: 0.35, options: UIView.AnimationOptions.transitionCrossDissolve, animations: {
//            let oldState = UIView.areAnimationsEnabled
//            UIView.setAnimationsEnabled(false)
//            JKStackManager.keyWindow.rootViewController = JKNavigationController.init(rootViewController: JKLoginViewController())
//            UIView.setAnimationsEnabled(oldState)
//        }, completion: nil)
    }

    static func showHomePage() {
        let tabBarController = JKStackManager.keyWindow.rootViewController as! JKTabBarController
        let navc = tabBarController.selectedViewController as! JKNavigationController
        tabBarController.selectedIndex = 0
        navc.popToRootViewController(animated: true)
    }



}

extension JKStackManager : UITabBarControllerDelegate{
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let nav = viewController as? JKNavigationController else { return true }
        if nav.viewControllers.first is JKMineViewController {
            return JKUserInfo.isLoginOrPushLogin()
        }else{
            return true
        }
    }
}
