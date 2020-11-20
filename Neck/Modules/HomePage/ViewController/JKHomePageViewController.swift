//
//  JKHomePageViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/6/22.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit
import FSPagerView

class JKHomePageViewController: JKViewController {

    private lazy var pagingView: JXPagingView = {
        let pagingView = JXPagingListRefreshView(delegate: self)
        pagingView.mainTableView.gestureDelegate = self
        pagingView.pinSectionHeaderVerticalOffset = 0
        pagingView.defaultSelectedIndex = 0
        pagingView.mainTableView.bounces = false
        pagingView.listContainerView.scrollView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        pagingView.mainTableView.panGestureRecognizer.require(toFail: self.navigationController!.interactivePopGestureRecognizer!)
        return pagingView
    }()

    private lazy var segmentedView: JXSegmentedView = {
        let segmentedView = JXSegmentedView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40))
        segmentedView.defaultSelectedIndex = 0
        segmentedView.indicators = [self.lineView]
        segmentedView.dataSource = self.segmentedViewDataSource
        segmentedView.isContentScrollViewClickTransitionAnimationEnabled = false
        segmentedView.listContainer = self.pagingView.listContainerView
        segmentedView.contentEdgeInsetLeft = PIX(110)
        segmentedView.contentEdgeInsetRight = PIX(110)
        segmentedView.delegate = self
        return segmentedView
    }()

    private lazy var segmentedViewDataSource: JXSegmentedTitleDataSource = {
        let segmentedViewDataSource =  JXSegmentedTitleDataSource()
        segmentedViewDataSource.titles = ["精选文章", "我的收藏"]
        segmentedViewDataSource.titleNormalColor = UIColor.black
        segmentedViewDataSource.titleSelectedColor = UIColor.black
        segmentedViewDataSource.isTitleColorGradientEnabled = true
        segmentedViewDataSource.isTitleZoomEnabled = true
        segmentedViewDataSource.reloadData(selectedIndex: 0)
        segmentedViewDataSource.titleNormalFont = UIFont.systemFont(ofSize: 15)
        segmentedViewDataSource.titleSelectedFont = UIFont.boldSystemFont(ofSize: 18)
        return segmentedViewDataSource
    }()

    private lazy var lineView: JXSegmentedIndicatorLineView = {
        let lineView = JXSegmentedIndicatorLineView()
        lineView.indicatorColor = UIColor.hexStringToColor("#1FD18F", 0.5)
        lineView.indicatorCornerRadius = 0
        lineView.indicatorHeight = 6
        return lineView
    }()

    private lazy var pagerView: FSPagerView = {
        let pagerView = FSPagerView()
        pagerView.automaticSlidingInterval = 3
        pagerView.interitemSpacing = 0
        pagerView.isInfinite = true
        pagerView.transformer = FSPagerViewTransformer.init(type: FSPagerViewTransformerType.linear)
        pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        pagerView.itemSize = CGSize.init(width: JKSizeHelper.width - 30, height: PIX(154))
        pagerView.delegate = self
        pagerView.dataSource = self
        pagerView.bounces = true
        return pagerView
    }()

    private lazy var pageControl: FSPageControl = {
        let pageControl = FSPageControl()
        pageControl.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        pageControl.hidesForSinglePage = true
        pageControl.setFillColor(UIColor.init(white: 1, alpha: 0.3), for: .normal)
        pageControl.setFillColor(UIColor.mainColor, for: .selected)
        pageControl.contentHorizontalAlignment = .center
        //绘制下标指示器的形状 (roundedRect绘制绘制圆角或者圆形)
        pageControl.setPath(UIBezierPath.init(roundedRect: CGRect.init(x: 0, y: 0, width: 4, height: 4), cornerRadius: 2.0), for: .normal)
        pageControl.setPath(UIBezierPath.init(roundedRect: CGRect.init(x: -3, y: 0, width: 10, height: 4), cornerRadius: 2.0), for: .selected)
        return pageControl
    }()


    private lazy var topView: JKHomePageView = {
        let view = JKHomePageView()
        return view
    }()


    var banners: [JKBannerModel] = [] {
        didSet {
            self.pageControl.numberOfPages = self.banners.count
            self.pagerView.reloadData()
            self.pageControl.currentPage = 0
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.requestData()
    }

    // MARK:  setUI
    private func setUI() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)

        self.view.addSubview(self.topView)
        self.topView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(JKSizeHelper.top + JKSizeHelper.navTop)
        }

        self.view.addSubview(self.pagingView)
        self.pagingView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.topView.snp.bottom)
        }

    }

    // MARK:  requestData
    private func requestData() {
        let bQuery = BmobQuery.init(className: "banner")
        bQuery?.findObjectsInBackground({[weak self] (objects, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                for i in 0..<(objects?.count)! {
                    guard let object = objects?[i] as? BmobObject else { return }
                    let model = JKBannerModel()
                    model.imageUrl = object.object(forKey: "imageUrl") as! String
                    self.banners.append(model)
                }
                self.pagingView.reloadData()
            }
        })
    }

}

extension JKHomePageViewController: FSPagerViewDelegate, FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return self.banners.count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        cell.imageView?.kfCache(self.banners[index].imageUrl, placeholderImage: UIImage.init(named: "icon_tab_community_nor"))
        cell.imageView?.contentMode = .scaleAspectFill
        return cell
    }

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        self.pageControl.currentPage = index

    }

    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        //        let currentI:Int = pagerView.currentIndex
        //        guard self.pageControl.currentPage != currentI else {
        //            return
        //        }
                self.pageControl.currentPage = pagerView.currentIndex // Or Use KVO with property "currentIndex"
    }

    func pagerView(_ pagerView: FSPagerView, willDisplay cell: FSPagerViewCell, forItemAt index: Int) {
        //        cell.imageView?.setLayerCornerRadius(radius: 5)

    }
}


extension JKHomePageViewController: JXPagingViewDelegate {

    func tableHeaderViewHeight(in pagingView: JXPagingView) -> Int {
        return Int(PIX(154))
    }

    func tableHeaderView(in pagingView: JXPagingView) -> UIView {
        return self.pagerView
    }

    func heightForPinSectionHeader(in pagingView: JXPagingView) -> Int {
        return 40
    }

    func viewForPinSectionHeader(in pagingView: JXPagingView) -> UIView {
        return self.segmentedView
    }

    func numberOfLists(in pagingView: JXPagingView) -> Int {
        return 2
    }

    func pagingView(_ pagingView: JXPagingView, initListAtIndex index: Int) -> JXPagingViewListViewDelegate {
        if index == 0 {
            return JKHomePageListViewController.init(type: "article")
        }
        else {
            return JKHomePageListViewController.init(type: "article")
        }
    }
}

extension JKHomePageViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int){
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = (index == 0)
    }
}

extension JKHomePageViewController: JXPagingMainTableViewGestureDelegate {
    func mainTableViewGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer == self.segmentedView.collectionView.panGestureRecognizer {
            return false
        }
        return gestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder()) && otherGestureRecognizer.isKind(of: UIPanGestureRecognizer.classForCoder())
    }
//    func pagingListContainerCollectionView(_ collectionView: JXPagingListContainerCollectionView, gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        if collectionView.contentOffset.x <= 0 {
//            if let delegate = otherGestureRecognizer.delegate, delegate.isKind(of: NSClassFromString("_FDFullscreenPopGestureRecognizerDelegate")!){
//                return true
//            }
//        }
//        return false
//    }

}

