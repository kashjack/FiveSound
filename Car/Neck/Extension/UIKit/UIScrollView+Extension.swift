//
//  UIScrollView+ReFresh.swift
//  SwiftLearn
//
//  Created by panhongliu on 2017/7/6.
//  Copyright © 2017年 wangsen. All rights reserved.
//

import UIKit
import ESPullToRefresh

extension UIScrollView{

    var header: ESRefreshHeaderAnimator {
        get {
            let h = ESRefreshHeaderAnimator.init(frame: CGRect.zero)
            h.pullToRefreshDescription = "Pull to refresh device"
            h.releaseToRefreshDescription = "Release to refresh device"
            h.loadingDescription = "Loading..."
            return h
        }
    }

    var footer: ESRefreshFooterAnimator {
        get {
            let f = ESRefreshFooterAnimator.init(frame: CGRect.zero)
            f.loadingMoreDescription = "上拉加载更多"
            f.noMoreDataDescription = "哎呀，抄底了"
            f.loadingDescription = "加载中..."
            return f
        }
    }

    func endrefresh(){
        self.es.stopPullToRefresh()
        self.es.stopLoadingMore()
    }
    
    func noMore(_ isEnd: Bool) {
        isEnd ? self.es.noticeNoMoreData() : self.es.resetNoMoreData()
    }
    
    
    //MARK: --添加下拉刷新
    public func addHeaderWithRefreshingBlock(refresh: @escaping  ()->Void) {
        self.es.addPullToRefresh(animator: self.header) {
            refresh()
        }
    }
    
    //MARK: --添加上拉刷新
    open func addFooterWithRefreshBlock(refresh: @escaping  ()->Void) {
        self.es.addInfiniteScrolling(animator: self.footer) {
            refresh()
        }
    }


    // MARK:  无数据，网络错误空页面
    func setEmptyView(image: UIImage?, titleStr: String, btnTitleStr: String, btnClickAction: @escaping (() -> Void)){
       
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
    
}

