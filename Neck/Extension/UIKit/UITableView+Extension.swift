//
//  WUTableViewCell.swift
//  WUKnowledge
//
//  Created by worldunionYellow on 2019/11/21.
//  Copyright © 2019 worldunionViolet. All rights reserved.
//

import UIKit

extension UITableView {

    ///快速注册cell
    func registerNibCell(_ name: String) {
        self.register(UINib.init(nibName: name, bundle: Bundle.main), forCellReuseIdentifier: name)
    }

    func registerClassCell(_ name: AnyClass, _ identifier: String) {
        self.register(name.self, forCellReuseIdentifier: identifier)
    }

    func registerNibHeaderFooter(_ name: String) {
        self.register(UINib.init(nibName: name, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: name)
    }

    func registerClassHeaderFooter(_ name: AnyClass, _ identifier: String) {
        self.register(name.self, forHeaderFooterViewReuseIdentifier: identifier)
    }

}
