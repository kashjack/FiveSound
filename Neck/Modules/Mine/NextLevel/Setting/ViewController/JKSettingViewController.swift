//
//  JKSettingViewController.swift
//  Neck
//
//  Created by worldunionYellow on 2020/7/29.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit

class JKSettingViewController: JKViewController {

    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.registerNibCell(JKSettingTableViewCell.nameOfClass)
        tableView.registerNibCell(JKSettingHeaderTableViewCell.nameOfClass)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 60
        return tableView
    }()

    private let titles = ["账号设置", "推送消息设置", "清除缓存", "当前版本", "关于我们"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }

    // MARK:  setUI
    private func setUI() {
        self.navigationItem.title = "设置"
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    // MARK: 获取缓存大小和内存大小
     private func cacheSize() -> CGFloat {
         let cachePath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
         let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
         return folderSize(filePath: cachePath) + folderSize(filePath: documentPath)
     }

     //计算单个文件的大小
     private func fileSize(filePath: String) -> UInt64 {
         let manager = FileManager.default
         if manager.fileExists(atPath: filePath) {
             do {
                 let attr = try manager.attributesOfItem(atPath: filePath)
                 let size = attr[FileAttributeKey.size] as! UInt64
                 return size
             } catch  {
                 print("error :\(error)")
                 return 0
             }
         }
         return 0
     }

     //遍历文件夹，返回多少M
     private func folderSize(filePath: String) -> CGFloat {
         let folderPath = filePath as NSString
         let manager = FileManager.default
         if manager.fileExists(atPath: filePath) {
             let childFilesEnumerator = manager.enumerator(atPath: filePath)
             var fileName = ""
             var folderSize: UInt64 = 0
             while childFilesEnumerator?.nextObject() != nil {
                 fileName = childFilesEnumerator?.nextObject() as? String ?? ""
                 let fileAbsolutePath = folderPath.strings(byAppendingPaths: [fileName])
                 folderSize += fileSize(filePath: fileAbsolutePath[0])
             }
             return CGFloat(folderSize) / (1024.0 * 1024.0)
         }
         return 0
     }

     // 清除缓存
     private func clearCache() {
         let cachPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
         let files = FileManager.default.subpaths(atPath: cachPath as String)
         for p in files! {
             let path = cachPath.appendingPathComponent(p)
             if FileManager.default.fileExists(atPath: path) {
                 do {
                     try FileManager.default.removeItem(atPath: path)
                 } catch {
                     print("error:\(error)")
                 }
             }
         }
     }

     //删除沙盒里的文件
     private func deleteFile() {
         let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as NSString
         let files = FileManager.default.subpaths(atPath: documentPath as String)
         for p in files! {
             let path = documentPath.appendingPathComponent(p)
             if FileManager.default.fileExists(atPath: path) {
                 do {
                     try FileManager.default.removeItem(atPath: path)
                 } catch {
                     print("error:\(error)")
                 }
             }
         }
     }

}

extension JKSettingViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: JKSettingHeaderTableViewCell.nameOfClass) as! JKSettingHeaderTableViewCell
                return cell
            }
            return UITableViewCell()
        }
        if indexPath.section == 1{
            let cell = UITableViewCell()
            cell.textLabel?.textAlignment = NSTextAlignment.center
            cell.textLabel?.textColor = UIColor.mainColor
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.textLabel?.text = "退出登录"
            cell.selectionStyle = .none
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
//            let cell = tableView.cellForRow(at: indexPath) as! JKSettingTableViewCell
//            let text = cell.labForTitle.text
//            if text == "账号设置"{
////                self.navigationController?.pushViewController(WUAccountViewController(), animated: true)
//            }
//            else if text == "清除缓存"{
//                let action: ((UIAlertAction) -> Void) = {[weak self]action in
//                    guard let `self` = self else { return }
//                    self.clearCache()
//                    self.deleteFile()
//                    self.tableView.reloadData()
//                }
////                self.alertDiaLog(title: "清理缓存", message: "确定删除所有缓存？离线内容及图片均会被清除", preferredStyle: UIAlertController.Style.alert, actionTitles: ["取消", "确定"], actions: [nil, action])
//            }
//            else if text == "当前版本"{
//                if kAppVersion != IOS_VERSION {
//                    guard let url = URL.init(string: kAppStoreURL) else { return }
//                    UIApplication.shared.openURL(url)
//                }else{
//                    HUD.flash(.label("当前是最新版本"), delay: 1)
//                }
//            }
//            else if text == "关于我们"{
////                self.navigationController?.pushViewController(WUWebViewController.init(type: WebType.about), animated: true)
//            }
        }
        else {

            let action: ((UIAlertAction) -> Void) = {action in
                JKUserInfo.logout()
            }
            self.alertDiaLog(title: "温馨提示", message: "退出后不会删除任何历史数据，下次登录依然可以使用本帐号", preferredStyle: UIAlertController.Style.alert, actionTitles: ["取消", "确定"], actions: [nil, action])
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.titles.count
        }else{
            return 1
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 10 }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 0.1 }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { return UIView() }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return UIView() }

}



