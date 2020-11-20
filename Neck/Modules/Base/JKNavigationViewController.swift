//
//  JKNavigationViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/6/22.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UINavigationBar.appearance().isTranslucent = false

        // Do any additional setup after loading the view.
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            interactivePopGestureRecognizer?.delegate = nil
        }
        //避免在首页疯狂左滑导致的卡死
        interactivePopGestureRecognizer?.isEnabled = (viewControllers.count > 0)
        super.pushViewController(viewController, animated: animated)
    }


}
