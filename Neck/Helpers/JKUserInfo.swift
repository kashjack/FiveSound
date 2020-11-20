//
//  JKUserInfoModel.swift
//  WUKnowledge
//
//  Created by worldunionYellow on 2019/11/20.
//  Copyright © 2019 worldunionViolet. All rights reserved.
//

import UIKit

let kUserInfoObjectId = "kUserInfoObjectId"
let kUserInfoUserId = "kUserInfoUserId"
let kUserInfoCorpId = "kUserInfoCorpId"
let kUserInfoCorpName = "kUserInfoCorpName"
let kUserInfoPhone = "kUserInfoPhone"
let kUserInfoNickname = "kUserInfoNickname"
let kUserInfoLoginType = "kUserInfoLoginType"
let kUserInfoUnionId = "kUserInfoUnionId"
let kUserInfoAvatar = "kUserInfoAvatar"
let kUserInfoSign = "kUserInfoSign"
let kUserInfoExpireDate = "kUserInfoExpireDate"
let kUserInfoCorpLogoUrl = "kUserInfoCorpLogoUrl"
let kUserInfoUserType = "kUserInfoUserType"
let kUserInfoEmployNo = "kUserInfoEmployNo"
let kUserInfoMoney = "kUserInfoMoney"


class JKUserInfo: NSObject {
    // 唯一标识
    var objectId: String? {
        set{ UserDefaults.standard.set(newValue, forKey: kUserInfoObjectId) }
        get{ return UserDefaults.standard.string(forKey: kUserInfoObjectId) }
    }

    // 用户Id
    var userId: Int {
        set{ UserDefaults.standard.set(newValue, forKey: kUserInfoUserId) }
        get{ return UserDefaults.standard.integer(forKey: kUserInfoUserId) }
    }

    // 用户公司Id
    var corpId: Int {
        set{ UserDefaults.standard.set(newValue, forKey: kUserInfoCorpId) }
        get{ return UserDefaults.standard.integer(forKey: kUserInfoCorpId) }
    }

    // 用户公司名
    var corpName: String? {
        set{ UserDefaults.standard.set(newValue, forKey: kUserInfoCorpName) }
        get{ return UserDefaults.standard.string(forKey: kUserInfoCorpName) }
    }

    // 手机号
    var phone: String? {
        set{ UserDefaults.standard.set(newValue, forKey: kUserInfoPhone) }
        get{ return UserDefaults.standard.string(forKey: kUserInfoPhone) }
    }

    // 员工工号
    var employNo: String? {
        set{ UserDefaults.standard.set(newValue, forKey: kUserInfoEmployNo) }
        get{ return UserDefaults.standard.string(forKey: kUserInfoEmployNo) }
    }

    // 微信openid
    var unionId: String? {
        set{ UserDefaults.standard.set(newValue, forKey: kUserInfoUnionId) }
        get{ return UserDefaults.standard.string(forKey: kUserInfoUnionId) }
    }

    // 昵称
    var nickname: String? {
        set{ UserDefaults.standard.set(newValue, forKey: kUserInfoNickname) }
        get{ return UserDefaults.standard.string(forKey: kUserInfoNickname) }
    }

    // 用户头像
    var avatar: String? {
        set{ UserDefaults.standard.set(newValue, forKey: kUserInfoAvatar) }
        get{ return UserDefaults.standard.string(forKey: kUserInfoAvatar) }
    }

    // 登录方式 mobile, wx, employNo
    var loginType: String? {
        set{ UserDefaults.standard.set(newValue, forKey: kUserInfoLoginType) }
        get{ return UserDefaults.standard.string(forKey: kUserInfoLoginType) }
    }

    // 个人简介
    var sign: String? {
        set{ UserDefaults.standard.set(newValue, forKey: kUserInfoSign) }
        get{ return UserDefaults.standard.string(forKey: kUserInfoSign) }
    }

    // 过期时间
    var expireDate: TimeInterval {
        set{ UserDefaults.standard.set(newValue, forKey: kUserInfoExpireDate) }
        get{ return UserDefaults.standard.double(forKey: kUserInfoExpireDate) }
    }

    // 企业logo
    var corpLogoUrl: String? {
        set{ UserDefaults.standard.set(newValue, forKey: kUserInfoCorpLogoUrl) }
        get{ return UserDefaults.standard.string(forKey: kUserInfoCorpLogoUrl) }
    }

    // 是否为企业用户
    var userType: Int {
        set{ UserDefaults.standard.set(newValue, forKey: kUserInfoUserType) }
        get{ return UserDefaults.standard.integer(forKey: kUserInfoUserType) }
    }

    var money: Double {
           set{ UserDefaults.standard.set(newValue, forKey: kUserInfoMoney) }
           get{ return UserDefaults.standard.double(forKey: kUserInfoMoney) }
       }



    static let instance = JKUserInfo()


    // MARK:  删除本地缓存信息
    private func deleteUserInfoFromSanBox() {
        JKUserInfo.instance.objectId = nil
        JKUserInfo.instance.userId = 0
        JKUserInfo.instance.corpId = 0
        JKUserInfo.instance.corpName = nil
        JKUserInfo.instance.avatar = nil
        JKUserInfo.instance.nickname = nil
        JKUserInfo.instance.unionId = nil
        JKUserInfo.instance.corpLogoUrl = nil
        JKUserInfo.instance.expireDate = 0
        JKUserInfo.instance.userType = 0
    }

    // MARK:  是否登录
    static func isLogin() -> Bool {
        return JKUserInfo.instance.objectId != nil
    }

    // MARK:  登录
    static func login(bmobResultClosure: BmobResultClosure?) {
        BmobUser.loginWithUsername(inBackground: JKUserInfo.instance.phone ?? "", password: "kashjack") { (user, error) in
            if let e = error, e.localizedDescription == "username or password incorrect."{
                let bUser = BmobUser()
                bUser.username = JKUserInfo.instance.phone
                bUser.mobilePhoneNumber = JKUserInfo.instance.phone
                bUser.password = "kashjack"
                bUser.setObject(JKUserInfo.instance.phone, forKey: "nickName")
                bUser.signUpInBackground(bmobResultClosure)
            }else{
                bmobResultClosure!(true, nil)
            }
        }
        //        WUStackManager.instance.logout()
        //        ShareSDK.cancelAuthorize(SSDKPlatformType.typeWechat, result: nil)
        //        NotificationCenter.default.post(name: NSNotification.Name.init(NotificationNameLoginStateChange), object: nil)
    }

    // MARK:  退出
    static func logout() {
        JKUserInfo.instance.deleteUserInfoFromSanBox()
        JKStackManager.logout()
//        WUSocketLoginHelper.share.disConnect()
//        ShareSDK.cancelAuthorize(SSDKPlatformType.typeWechat, result: nil)
//        NotificationCenter.default.post(name: NSNotification.Name.init(NotificationNameLoginStateChange), object: nil)
    }

    // MARK:  登录
    static func saveInfo() {
        let user = BmobUser.current()!
        JKUserInfo.instance.objectId = user.objectId
        JKUserInfo.instance.nickname = user.object(forKey: "nickName") as? String
//        JKUserInfo.instance.sessionId = json["data"]["sessionId"].stringValue
//        JKUserInfo.instance.userId = json["data"]["userId"].intValue
//        JKUserInfo.instance.corpName = json["data"]["corpName"].stringValue
//        JKUserInfo.instance.corpId = json["data"]["corpId"].intValue
//        JKUserInfo.instance.avatar = json["data"]["avatar"].stringValue
//        JKUserInfo.instance.sign = json["data"]["sign"].stringValue
//        JKUserInfo.instance.unionId = json["data"]["unionId"].stringValue
//        JKUserInfo.instance.expireDate = json["data"]["expireDate"].doubleValue
//        JKUserInfo.instance.corpLogoUrl = json["data"]["corpLogoUrl"].stringValue
//        JKUserInfo.instance.userType = json["data"]["userType"].intValue
//        NotificationCenter.default.post(name: NSNotification.Name.init(NotificationNameLoginStateChange), object: nil)
    }

    // MARK: 是否需要登录
    static func isLoginOrPushLogin() -> Bool {
        if JKUserInfo.isLogin() {
            return true
        }else{
            let nav = JKNavigationController.init(rootViewController: JKLoginViewController())
            JKViewController.topViewController()?.present(nav, animated: true, completion: nil)
            return false
        }
    }
    
}
