//
//  JKDeviceTableViewCell.swift
//  Neck
//
//  Created by 周美汝 on 2020/11/28.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit
import CoreBluetooth

class JKDeviceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labForName: UILabel!
    
    var peripheral: CBPeripheral? {
        didSet {
            guard let peripheral = self.peripheral else { return }
            self.labForName.text = peripheral.name ?? "Unknow device"
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
