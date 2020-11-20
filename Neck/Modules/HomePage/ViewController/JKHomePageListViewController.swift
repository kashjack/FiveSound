//
//  JKHomePageListViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/6/29.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKHomePageListViewController: JKViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.registerNibCell(JKArticleTableViewCell.nameOfClass)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 500
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    private var listViewDidScrollCallback: ((UIScrollView) -> ())?
    private var dataSource = [JKArticleModel]()
    private var type: String = ""

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }

    convenience init(type: String) {
        self.init()
        self.type = type

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        //        self.setAction()
        self.requestData()

    }

    private func setUI(){

        self.view.addSubview(self.tableView)

    }

    // MARK:  requestData
    private func requestData() {
        let bQuery = BmobQuery.init(className: type)
        bQuery?.findObjectsInBackground({[weak self] (objects, error) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                for i in 0..<(objects?.count)! {
                    guard let object = objects?[i] as? BmobObject else { return }
                    let model = JKArticleModel()
                    model.objectId = object.objectId
                    model.articleName = object.object(forKey: "articleName") as! String
                    model.articleType = object.object(forKey: "articleType") as! String
                    model.imageUrl = object.object(forKey: "imageUrl") as! String
                    model.url = object.object(forKey: "url") as! String
                    model.readNum = object.object(forKey: "readNum") as! Int
                    self.dataSource.append(model)
                }
                self.tableView.reloadData()
            }
        })
    }

}

extension JKHomePageListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JKArticleTableViewCell.nameOfClass, for: indexPath) as! JKArticleTableViewCell
        cell.model = self.dataSource[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataSource[indexPath.row]
        self.Push(vc: JKArticleWebViewController.init(model: model))
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.listViewDidScrollCallback?(scrollView)
    }
    func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 0.1 }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 0.1 }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return UIView() }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return UIView() }
}

extension JKHomePageListViewController: JXPagingViewListViewDelegate {
    func listView() -> UIView {
        return view
    }

    func listViewDidScrollCallback(callback: @escaping (UIScrollView) -> ()) {
        self.listViewDidScrollCallback = callback
    }

    func listScrollView() -> UIScrollView {
        return self.tableView
    }

    func listWillAppear() {
        print("\(self.title ?? ""):\(#function)")
    }

    func listDidAppear() {
        print("\(self.title ?? ""):\(#function)")
    }

    func listWillDisappear() {
        print("\(self.title ?? ""):\(#function)")
    }

    func listDidDisappear() {
        print("\(self.title ?? ""):\(#function)")
    }
}
