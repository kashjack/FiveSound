//
//  WKWebView+Category.swift
//  SLJK3
//
//  Created by liu jinliang on 2018/1/5.
//  Copyright © 2018年 worldunion.com.cn. All rights reserved.
//

import WebKit
extension WKWebView {
    //清除cookie
    func removeWKWebViewCookies(){
        
        
        _ = HTTPCookie(properties: [
            HTTPCookiePropertyKey(rawValue: "HttpOnly"):"false"]
        )
        //iOS9.0以上使用的方法
        if #available(iOS 9.0, *) {
            let dataStore = WKWebsiteDataStore.default()
            dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), completionHandler: { (records) in
                for record in records{
                    //清除本站的cookie
//                    if record.displayName.contains("sina.com"){//这个判断注释掉的话是清理所有的cookie
                        WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {
                            //清除成功
                           debugPrint("清除成功\(record)")
                        })
//                    }
                }
            })
        } else {
            //ios8.0以上使用的方法
            let libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let cookiesPath = libraryPath! + "/Cookies"
            do {
                try FileManager.default.removeItem(atPath: cookiesPath)
            }catch {
                
            }
        }
    }
}
