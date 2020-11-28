//
//  JKBlueToothHelper.swift
//  Neck
//
//  Created by 周美汝 on 2020/11/28.
//  Copyright © 2020 worldunionYellow. All rights reserved.
//

import UIKit
import BluetoothKit

class JKBlueToothHelper: NSObject {
    
    static let shared = JKBlueToothHelper()
    
    let central = BKCentral()
    

    
}
extension JKBlueToothHelper: BKCentralDelegate{
    func central(_ central: BKCentral, remotePeripheralDidDisconnect remotePeripheral: BKRemotePeripheral) {
        do {
//            try central.disconnectRemotePeripheral(remotePeripheralViewController.remotePeripheral)
        } catch let error {
            printLog("Error disconnecting remote peripheral: \(error)")
        }
    }
}
extension JKBlueToothHelper: BKAvailabilityObserver {
    func availabilityObserver(_ availabilityObservable: BKAvailabilityObservable, availabilityDidChange availability: BKAvailability) {
        if availability == .available {
//            scan()
        } else {
            central.interruptScan()
        }
    }
    
    func availabilityObserver(_ availabilityObservable: BKAvailabilityObservable, unavailabilityCauseDidChange unavailabilityCause: BKUnavailabilityCause) {
        
    }
}
