//
//  Macros.swift
//  MobileProject
//
//  Created by xuwen on 2017/3/21.
//  Copyright © 2017年 xuwen. All rights reserved.
//

import Foundation
import UIKit

let kAppDelegate:AppDelegate = {
    return UIApplication.shared.delegate as! AppDelegate
}()

//登录模块
//微信登录token
let kNotification_Login_WX_ACCESS_TOKEN:String = "kNotification_Login_WX_ACCESS_TOKEN"
//微信登录openId
let kNotification_Login_WX_OPEN_ID:String = "kNotification_Login_WX_OPEN_ID"

let kNotification_Collect_Reload:String = "kNotification_Collect_Reload"
//刷新订单列表的通知名
let kNotification_OrderList_Reload:String = "kNotification_OrderList_Reload"
//刷新订单详情的通知名
let kNotification_OrderDetail_Reload:String = "kNotification_OrderDetail_Reload"
//登录成功发送全局通知
let kNotification_Login_Success:String = "kNotification_Login_Success"
let kNotification_Logout_Success:String = "kNotification_Logout_Success"

//网络请求结果通知
let kNotification_Request_Status = "kNotification_Request_Status"
//对指定页面进行注册和通知刷新
let kNotification_Base_Refresh:String = "kNotification_Base_Refresh"

//网络状态通知
let kNotification_Neetwork_Status = "kNotification_Neetwork_Status"

//MARK: 发送通知
func notificationPost(_ name:String,_ object:Any? = nil, _ userInfo:[AnyHashable : Any]? = nil) {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: object, userInfo: userInfo)
}
//MARK: --融云配置-------
//与云掌柜对接的自定义标识
let kYZGCustomMessage:String = "YZGCustomMessage"
let RCCustomMessageTypeIdentifier:String = "YZGRC:CustomMsg"

//MARK: --处理className xxx.classname -> classname
func kGetClassName(className:NSString) -> String {
//    var displayName:String = Bundle.main.infoDictionary["CFBundleDisplayName"] ?? ""
    let cName:String = "HomePlus" + "."
    let name:String = className.replacingOccurrences(of: cName, with: "")
    return name
}
//

enum kAppButtonBackgroundImage {
    case smallBackgroundImage
    
}


