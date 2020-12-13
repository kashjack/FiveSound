//
//  AppConst.swift
//  HomePlusTS
//
//  Created by worldunionViolet on 2019/3/19.
//  Copyright © 2019 worldunionViolet. All rights reserved.
//

import Foundation
import UIKit

// MARK:  基地址
var kBaseUrl = "https://kmtest.worldunion.com.cn/api" // 测试
var kWSUrl = "ws://192.168.35.152:9013/ws"


//var kBaseUrl = "https://api.universitywu.com/api" // 正式
//var kWSUrl = "wss://api.universitywu.com/ws"// 正式


//MARK: 应用地址
let kAppStoreURL = "https://itunes.apple.com/cn/app/id1495289526?mt=8"

//微信
let kWXAPPID: String = "wxed705852bd3284c3"
let kWXSecret: String = "ba4bbd34e9575905eee870124919cba1"

// Bugly
let kBuglyAppId = "5fcb81849e"

// Bmob
let kBmobAppId = "e209e44691e0e1b4a0815cd1825b0592"

//UniversalLink
let kUniversalLink = "https://adyd.t4m.cn/"




//MARK: --工程信息
let infroDictionary = Bundle.main.infoDictionary
/// 获取项目名称
let executableFile:String = infroDictionary?[kCFBundleExecutableKey! as String] as! String
/// app名称
let kAppName: String = infroDictionary?["CFBundleDisplayName"] as! String
/// app版本
let kAppVersion: String = infroDictionary?["CFBundleShortVersionString"] as! String
/// app build版本
let kAppBuild: String = infroDictionary?["CFBundleVersion"] as! String
/// app bundleID
let kAppIdentifier: String = infroDictionary?["CFBundleIdentifier"] as! String


//设备信息
let kiOSVersion = UIDevice.current.systemVersion //iOS版本
let identifierNumber = UIDevice.current.identifierForVendor //设备udid
let systemName = UIDevice.current.systemName //设备名称
let model = UIDevice.current.model //设备型号
//let modelName = UIDevice.current.modelName //设备具体型号
let localizedModel = UIDevice.current.localizedModel //设备区域化型号如A1533

//FIXME:-你想要修改的bug
let IS_IPAD = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
let IS_IPHONE  = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone


//日志输出：
//Log
func printLog<T>( _ message: T, file: String = #file, method: String = #function, line: Int = #line){
    #if DEBUG
    print("")
    print("****************************************")
    debugPrint("\((file as NSString).lastPathComponent)[\(line)], \(method): ")
    print(message)
    print("****************************************")
    print("")
    #endif
}


// MARK:  通知
let kRequestErrorNotification = "kRequestErrorNotification"
let NotificationNameBlueToothStateChange = "NotificationNameBlueToothStateChange"
let NotificationNameBuyLiving = "NotificationNameBuyLiving"
let NotificationNameScheduled = "NotificationNameScheduled"
var kBuyNotice = "1.购买后您可观看《世联地产案例大赏》系列所有直播\r\n\r\n2.购买后可永久免费观看回播\r\n\r\n3.直播课程安排解释归世联云学院所有\r\n\r\n4.如有疑问，请添加客服微信：SLYXY66"
var IOS_AUDITING_STATUS = 0 // 0已审核，1审核中
var IOS_FORCE_UPDATE = 0 // 0非强制更新，1强制更新
var IOS_UPDATE_CONTENT = "" // 更新内容
var IOS_VERSION = ""  // ios版本


let ClassNameNeck = "neck"
let ClassNameBanner = ""



