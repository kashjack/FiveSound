//
//  JKTabBarViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/6/22.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKTabBarController: UITabBarController {

    private let VCArr = [
        JKHomePageViewController(),
        JKCommunityViewController(),
        JKMineViewController()
    ]
    private let titleArr = ["首页", "社区", "我的"]

    private let defaultImageArr = [
        UIImage.init(named: "icon_tab_homePage_nor"),
        UIImage.init(named: "icon_tab_community_nor"),
        UIImage.init(named: "icon_tab_mine_nor")
    ]
    private let selectImageArr = [
        UIImage.init(named: "icon_tab_homePage_sel"),
        UIImage.init(named: "icon_tab_community_sel"),
        UIImage.init(named: "icon_tab_mine_sel")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }

    // MARK:  setUI
    private func setUI() {
        if #available(iOS 10.0, *) {
            self.tabBar.unselectedItemTintColor = UIColor.white
        }
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.gray, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.mainColor, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11)], for: .selected)
    }


      init() {
        super.init(nibName: nil, bundle: nil)
        for i in 0..<self.titleArr.count{
            self.addChildVC(childController: VCArr[i], title: titleArr[i], defaultImage: defaultImageArr[i], selectedImage: selectImageArr[i])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func addChildVC(childController: UIViewController, title: String, defaultImage: UIImage?, selectedImage: UIImage?) {
        childController.tabBarItem.title = title
        childController.tabBarItem = UITabBarItem.init(title: title, image: defaultImage, selectedImage: selectedImage)
        childController.tabBarItem.selectedImage = selectedImage!.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.image = defaultImage!.withRenderingMode(.alwaysOriginal)
        let naVC = JKNavigationController.init(rootViewController: childController)
        self.addChild(naVC)
    }
}
