//
//  UICollectionView+Extension.swift
//  HomePlus
//
//  Created by worldunionViolet on 2018/5/28.
//  Copyright © 2018年 worldunion. All rights reserved.
//

import UIKit

extension UICollectionView {

    ///快速注册cell
    func registerNibCell(_ name: String) {
        self.register(UINib.init(nibName: name, bundle: Bundle.main), forCellWithReuseIdentifier: name)
    }

    func registerClassCell(_ name: AnyClass, _ identifier: String) {
        self.register(name.self, forCellWithReuseIdentifier: identifier)
    }

    func registerNibHeader(_ name: String) {
        self.register(UINib.init(nibName: name, bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: name)
    }

    func registerClassHeader(_ name: AnyClass, _ identifier: String) {
        self.register(name.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
    }

    func registerNibFooter(_ name: String) {
        self.register(UINib.init(nibName: name, bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: name)
    }

    func registerClassFooter(_ name: AnyClass, _ identifier: String) {
        self.register(name.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
    }
}
