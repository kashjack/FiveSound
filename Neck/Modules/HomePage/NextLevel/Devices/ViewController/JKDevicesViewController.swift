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
        JKBlueToothHelper.shared.connectStatesUpdate = {[weak self] states in
            guard let self = self else { return }
            WULoadingView.hide()
            if states == .connect {
                JKBlueToothHelper.shared.centralManager.stopScan()
                self.dataSource.remove(at: indexPath.row)
                self.tableView.reloadData()
                WULoadingView.show("Connected")
                DispatchQueue.main.after(1) {[weak self] in
                    guard let self = self else { return }
                    self.dismiss(animated: false) {
                        JKViewController.topViewController()?.navigationController?.pushViewController(JKRadioViewController(), animated: true)
                    }
//                    let intArr2: [UInt8] = [0x55, 0xaa, 2, 0x82, 4, 0x28, 0xe, 0x42]
//                    JKBlueToothHelper.shared.writeCharacteristice(value: intArr2)
//                    let intArr3: [UInt8] = [0x55, 0xaa, 0, 1, 3, 0xfc]
//                    JKBlueToothHelper.shared.writeCharacteristice(value: intArr3)
//                    let intArr4: [UInt8] = [0x55, 0xaa, 1, 0x81, 3, 5, 0x76]
//                    JKBlueToothHelper.shared.writeCharacteristice(value: intArr4)
//                    let intArr5: [UInt8] = [0x55, 0xaa, 0, 2, 0xd, 0xf1]
//                    JKBlueToothHelper.shared.writeCharacteristice(value: intArr5)
//                    let intArr6: [UInt8] = [0x55, 0xaa, 4, 0x84, 2, 0, 0x48, 0x26, 3, 5]
//                    JKBlueToothHelper.shared.writeCharacteristice(value: intArr6)
//                    let intArr7: [UInt8] = [0x55, 0xaa, 0, 2, 0x11, 0xed]
//                    JKBlueToothHelper.shared.writeCharacteristice(value: intArr7)
//                    let intArr8: [UInt8] = [0x55, 0xaa, 1, 0x82, 0x11, 0, 0x6c]
//                    JKBlueToothHelper.shared.writeCharacteristice(value: intArr8)
//                    let intArr9: [UInt8] = [0x55, 0xaa, 0, 2, 0x13, 0xeb]
//                    JKBlueToothHelper.shared.writeCharacteristice(value: intArr9)
//                    let intArr10: [UInt8] = [0x55, 0xaa, 1, 0x82, 0x13, 0, 0x6a]
//                    JKBlueToothHelper.shared.writeCharacteristice(value: intArr10)
//                    let intArr11: [UInt8] = [0x55, 0xaa, 0, 2, 0xe, 0]
//                    JKBlueToothHelper.shared.writeCharacteristice(value: intArr11)
//                    let intArr12: [UInt8] = [0x55, 0xaa, 1, 0x82, 0xe, 1, 0x6e]
//                    JKBlueToothHelper.shared.writeCharacteristice(value: intArr12)
//                    let intArr13: [UInt8] = [0x55, 0xaa, 0, 3, 0x20, 0xdd]
//                    JKBlueToothHelper.shared.writeCharacteristice(value: intArr13)
                }
            }
            else if states == .disconnect {
                WULoadingView.show("Disconnected")
                JKBlueToothHelper.shared.scanDevice()
            }
        }
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
