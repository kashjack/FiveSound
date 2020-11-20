//
//  Appdelegate+Extension.swift
//  WUKnowledge
//
//  Created by worldunionYellow on 2019/11/19.
//  Copyright © 2019 worldunionViolet. All rights reserved.
//

import UIKit

extension AppDelegate {

    // MARK:  热重载
    func setHotReload() {
        #if DEBUG
        Bundle(path: "/Applications/InjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
        #endif
    }

    // MARK:  分享
    func setShareSDK() {
//        ShareSDK.registPlatforms { (register) in
//            register?.setupWeChat(withAppId: kWXAPPID, appSecret: kWXSecret, universalLink: kUniversalLink)
//        }
    }

    // MARK:  界面管理器
    func setUpUIStack() {
        JKStackManager.shared.setupTabbarController()
    }

    // MARK:  Bmob
    func setUpBmob() {
        Bmob.register(withAppKey: kBmobAppId)
    }

    // MARK:  Bugly
    func setBugly() {
//        #if DEBUG
        Bugly.start(withAppId: kBuglyAppId)
//        #endif
    }

    // MARK:  防止上线出错
    func setUpBaseUrl() {
        #if DEBUG || RELEASE
        #endif
    }


}
