//
//  JKViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/6/29.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit
import WebKit

class JKArticleWebViewController: JKViewController {

    private lazy var webView: WKWebView = {
        let webView = WKWebView.init(frame: CGRect.zero, configuration: self.configuration)
        webView.scrollView.bounces = false
        webView.navigationDelegate = self
        return webView
    }()

    private lazy var progressView: UIProgressView = {
        let progress = UIProgressView()
        progress.progress = 0
        progress.tintColor = UIColor.mainColor
        return progress
    }()

    private lazy var configuration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        let userContentController = WKUserContentController()
        configuration.userContentController = userContentController
        configuration.preferences = WKPreferences()
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences.minimumFontSize = 0
        configuration.preferences.javaScriptEnabled = true
        return configuration
    }()

    private var model = JKArticleModel()
    private var isObserver: Bool = false

    deinit {
        if self.isObserver {
            self.webView.removeObserver(self, forKeyPath: "title")
            self.webView.removeObserver(self, forKeyPath: "estimatedProgress")
            self.webView.configuration.userContentController.removeScriptMessageHandler(forName: "getUserInfo")
        }
    }

    convenience init(model: JKArticleModel) {
        self.init()
        self.model = model
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.requestData()
        self.addReadNum()
    }
    

    // MARK:  setUI
    private func setUI() {
        self.clearCache()
        self.view.addSubview(self.webView)
        self.webView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        self.view.addSubview(self.progressView)
        self.progressView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }

    override func Pop(_ animated: Bool = true) {
        if self.webView.canGoBack {
            self.webView.goBack()
        }else{
            super.Pop()
        }
    }

    // MARK:  requestData
    private func requestData() {
        var request = URLRequest(url: URL(string: self.model.url)!)
        request.addValue(JKUserInfo.instance.objectId ?? "", forHTTPHeaderField: "sessionId")
        self.webView.load(request)
    }

    // MARK:  增加阅读数
    private func addReadNum() {
        JKBmobHelper.updateObject(className: "article", id: self.model.objectId, dic: ["readNum" : self.model.readNum + 1]) { (isSuccess, error) in
            if isSuccess {
                
            }
        }
    }

    // MARK: 清空缓存
    func clearCache() {
        let dateFrom: NSDate = NSDate.init(timeIntervalSince1970: 0)
        if #available(iOS 9.0, *) {
            let websiteDataTypes: NSSet = WKWebsiteDataStore.allWebsiteDataTypes() as NSSet
            WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: dateFrom as Date) {
                printLog("清空缓存完成")
            }
        } else {
            let libraryPath = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)[0]
            let cookiesFolderPath = libraryPath.appending("/Cookies")//stringByAppendingString("/Cookies")
            let _: NSError
            try? FileManager.default.removeItem(atPath: cookiesFolderPath)
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object is WKWebView && (object as! WKWebView == self.webView){
            if keyPath == "title" {
                self.navigationItem.title = self.webView.title
            }
            else if keyPath == "estimatedProgress" {
                self.progressView.isHidden = (self.webView.estimatedProgress >= 1)
                self.progressView.progress = Float(self.webView.estimatedProgress)
            }else{
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }else{
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

}

extension JKArticleWebViewController: WKNavigationDelegate{

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript("document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '100%'", completionHandler: nil)
    }

    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let card = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, card)
        }
    }

    func webView(_ wkWebView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            decisionHandler(WKNavigationActionPolicy.allow)
    }
}

