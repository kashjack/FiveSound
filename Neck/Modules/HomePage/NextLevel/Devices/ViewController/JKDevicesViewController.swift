//
//  JKDevicesViewController.swift
//  Neck
//
//  Created by 周美汝 on 2020/11/28.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit
import CoreBluetooth

class JKDevicesViewController: JKViewController {
    
    @IBOutlet weak var btnForBack: UIButton!
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerNibCell(JKDeviceTableViewCell.nameOfClass)
        tableView.registerNibHeaderFooter(JKDeviceTableViewHeader.nameOfClass)
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        return tableView
    }()
    
    private let publishDataSource = PublishSubject<[CBPeripheral]>()
    private var dataSource = [CBPeripheral]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setAction()
        self.requestData()
        self.setReceiveData()
    }

    // MARK:  setUI
    private func setUI() {

        let visualEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: visualEffect)
        blurView.alpha = 0.4
        self.view.addSubview(blurView)
        blurView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.btnForBack.snp.bottom)
        }
        
        self.view.addSubview(self.tableView)
        self.tableView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.btnForBack.snp.bottom)
        }

    }
    
    // MARK:  setAction
    private func setAction() {
        self.btnForBack.rx.tap.subscribe(onNext: {[weak self] element in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: self.disposeBag)
        
        JKBlueToothHelper.shared.deviceUpdate = {[weak self] (peripheral) in
            guard let self = self else { return }
            for oldPeripheral in self.dataSource {
                if oldPeripheral.identifier == peripheral.identifier {
                    return
                }
            }
            self.publishDataSource.onNext(self.dataSource + [peripheral])
        }

        self.tableView.addHeaderWithRefreshingBlock {
            JKBlueToothHelper.shared.scanDevice()
            self.dataSource.removeAll()
            DispatchQueue.main.after(1) { [weak self] in
                guard let self = self else { return }
                self.tableView.endrefresh()
            }
        }
        
        self.publishDataSource.subscribe(onNext: {[weak self] (element) in
            guard let self = self else { return }
            self.dataSource = element
            self.tableView.reloadData()
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
    }
    
    // MARK:  requestData
    private func requestData() {
        JKBlueToothHelper.shared.scanDevice()
    }
    
    private func setReceiveData(){
        JKBlueToothHelper.shared.receiveUpdate = { [weak self] type in
            guard let self = self else { return }
            if type == .device {
                if JKSettingHelper.shared.deviceStatus == .radio {
                    self.dismiss(animated: false) {
                        JKViewController.topViewController()?.navigationController?.pushViewController(JKRadioViewController(), animated: true)
                    }
                }else{
                    self.dismiss(animated: false) {
                        JKViewController.topViewController()?.navigationController?.pushViewController(JKMemoryViewController.init(type: JKSettingHelper.shared.deviceStatus), animated: true)
                    }
                }
            }
        }
    }

}

extension JKDevicesViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: JKDeviceTableViewCell.nameOfClass) as! JKDeviceTableViewCell
        if indexPath.section == 0 {
            cell.peripheral = JKBlueToothHelper.shared.connectPeripheral
        }else{
            cell.peripheral = self.dataSource[indexPath.row]
        }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return JKBlueToothHelper.shared.connectPeripheral == nil ? 0 : 1
        }else{
            return self.dataSource.count
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            JKBlueToothHelper.shared.cancelConnection()
        }else{
            JKBlueToothHelper.shared.connectDevice(peripheral: self.dataSource[indexPath.row])
        }
        WULoadingView.show(view: self.view, isUserInteractionEnabled: false)
        
        // MARK:  蓝牙连接状态变化
        NotificationCenter.default.rx.notification(Notification.Name.init(NotificationNameBlueToothStateChange)).subscribe(onNext: {[weak self](notification) in
            guard let self = self else { return }
            WULoadingView.hide()
            if JKBlueToothHelper.shared.connectPeripheral != nil {
                JKBlueToothHelper.shared.centralManager.stopScan()
                self.dataSource.remove(at: indexPath.row)
                self.tableView.reloadData()
                WULoadingView.show("Connected")
                DispatchQueue.main.after(1) {
                    JKSettingHelper.getDeviceInfo()
                }
            }
            else {
                WULoadingView.show("Disconnected")
                JKBlueToothHelper.shared.scanDevice()
            }
        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: self.disposeBag)
        
        
//        JKBlueToothHelper.shared.connectStatesUpdate = {[weak self] states in
//            guard let self = self else { return }
//            WULoadingView.hide()
//            if states == .connect {
//                JKBlueToothHelper.shared.centralManager.stopScan()
//                self.dataSource.remove(at: indexPath.row)
//                self.tableView.reloadData()
//                WULoadingView.show("Connected")
//                DispatchQueue.main.after(1) {
//                    JKSettingHelper.getDeviceInfo()
//                }
//            }
//            else if states == .disconnect {
//                WULoadingView.show("Disconnected")
//                JKBlueToothHelper.shared.scanDevice()
//            }
//        }
    }
    func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 0.1 }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: JKDeviceTableViewHeader.nameOfClass) as! JKDeviceTableViewHeader
        header.labForTitle.text = ["Paired device", "Devices found"][section]
        return header
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return UIView() }
}
